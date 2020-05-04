function [t,u] = integrator(L, Nx, PeriodicFlag, T, Nt, u0, spacedef, casedef)
% Inputs:
% 
% L: length of the physical domain, x is from 0 to L
% Nx: number of points which to discretize x
% Periodicflag: if 1, then periodic
%               if 0, then non-periodic
% T: lenght of the time domain, t is from 0 to T
% Nt: number of points which to discretise t (note that ode45 uses dt, this is for reporting only)
% spacedef: string to select spacial derivative operator
% casedef: string to select governing equation
% u0: function of x_s defining the initial condition
% 
% Output:
% t: time vector
% u: solution vector

% Create the spacial domain
if (PeriodicFlag == 0)
    dx = L/Nx;
else
    dx = L/(Nx-1);
end
x = dx*linspace(0, Nx-1, Nx).';

% Create the time domain
dt = T/(Nt-1);
t = dt*linspace(0,Nt-1,Nt);

% Define the spacial operator
if strcmpi('Central2First', spacedef)
    D1 = sparse(Central2(Nx, dx, PeriodicFlag));
elseif strcmpi('First', spacedef)
    D1 = sparse(First(Nx, dx));
elseif strcmpi('Second', spacedef)
    D1 = sparse(Second(Nx, dx));
elseif strcmpi('Third', spacedef)
    D1 = sparse(Third(Nx, dx));
else
    error(sprintf('Unknown spacdef string = %s',spacedef));
end

% Define the initial condition
syms x_s
u0 = double(subs(u0, x_s, x));

% Run the case
if strcmpi('LinearAdvection', casedef)
    [t,u] = ode45(@(t,y) LinearAdvection(t,y,D1), t, u0);
elseif strcmpi('ConservativeBurgers', casedef)
    [t,u] = ode45(@(t,y) ConservativeBurgers(t,y,D1), t, u0);
else
    error(sprintf('Uknown casedef string = %s',casedef));
end

return
end
%% Linear Advection
function udot = LinearAdvection(t, u, D)
    udot = -D * u;
    return
end
%% Conservative Burgers
function udot = ConservativeBurgers(t, u, D)
    udot = -0.5*(D * (u.*u));
    return
end
%% Euler ODE
function qdot = EulerODE(t, q, D)
    % properties
    g = 1.4;
    % size of domain
    Nx = size(D,1);

    % extract [rho, u, p]
    rho = q(1:Nx);
    u   = q((Nx+1):(2*Nx));
    p   = q((2*Nx+1):(3*Nx));

    % time derivatives
    drhodt = -u .* (D * rho) - rho      .* (D * u);
    dudt   = -u .* (D * u)   - (D * p) ./  rho;
    dpdt   = -u .* (D * p)   - g * p    .* (D * u);

    % work on left boundary (constant total Temperature & pressure)
    c2 = g * p(1) / rho(1);
    M2 = u(1)*u(1)/c2;
    X = [1                 1/c2                1/c2; ...
         0 -1/(rho(1)*sqrt(c2)) 1/(rho(1)*sqrt(c2)); ...
         0                   1                   1];

    Xinv = inv(X);
    dwdt = Xinv * [drhodt(1); dudt(1); dpdt(1)];
    if (abs(u(1)) > 1e-10)
      ap   = (1/p(1) - 1/(rho(1)*c2) + (g-1)*M2/(rho(1)*sqrt(c2)*u(1)));
      am   = (1/p(1) - 1/(rho(1)*c2) - (g-1)*M2/(rho(1)*sqrt(c2)*u(1)));
      bp   = (1-M2/2)/p(1) + g*M2/(2*rho(1)*c2) + g*M2/(rho(1)*sqrt(c2)*u(1));
      bm   = (1-M2/2)/p(1) + g*M2/(2*rho(1)*c2) - g*M2/(rho(1)*sqrt(c2)*u(1));
    else
      ap   = (1/p(1) - 1/(rho(1)*c2));
      am   = (1/p(1) - 1/(rho(1)*c2));    
      bp   = (1-M2/2)/p(1) + g*M2/(2*rho(1)*c2);
      bm   = (1-M2/2)/p(1) + g*M2/(2*rho(1)*c2);
    end
    b1        = -(2*rho(1)*(bm*ap-bp*am))/(g*M2*ap+2*bp);
    b2        = -(g*M2*am+2*bm)/(g*M2*ap+2*bp);

    dwdt(1)   = b1*dwdt(2);
    dwdt(3)   = b2*dwdt(2);
    dqdt      = X * dwdt;
    drhodt(1) = dqdt(1);
    dudt(1)   = dqdt(2);
    dpdt(1)   = dqdt(3);

    % work on right boundary (constant static temp)
    c2 = g * p(Nx) / rho(Nx);
    M2 = u(Nx)*u(Nx)/c2;
    X  = [1                  1/c2                 1/c2; ...
          0 -1/(rho(Nx)*sqrt(c2)) 1/(rho(Nx)*sqrt(c2)); ...
          0            1           1];

    Xinv = inv(X);
    dwdt = Xinv * [drhodt(Nx); dudt(Nx); dpdt(Nx)];
    p1   = 101325;
    p2   = 0.8*p1;
    a    = 2.5e-2;
    s    = 1e-3;
    dp   = (p2-p1)/2/s*(sech((t-a)/s))^2;

    dwdt(2)    = -dwdt(3)+dp;
    dqdt       = X * dwdt;
    drhodt(Nx) = dqdt(1);
    dudt(Nx)   = dqdt(2);
    dpdt(Nx)   = dqdt(3);

    qdot = [drhodt; dudt; dpdt];
end
%% Pade ODE
function D = Pade346(Nx,dx,PeriodicFlag)
    %
    % [C,kmax,kstar] = Pade346(Nx,dx,PeriodicFlag)
    %
    % Return the inv(A)*B matrix for the 3-4-6 Pade scheme on a grid
    % of Nx points with equal spacing dx.
    %
    % INPUTS:
    %
    % PeriodicFlag = 1 = TRUE;
    % PeriodicFlag = 0 = FALSE;
    %
    % OUTPUTS:
    %
    % C     = inv(A)*B
    % kmax  = maximum wavenumber
    % kstar = maximum wavenumber for a given accuracy
    %


    V0 = ones([1,Nx]);
    V1 = ones([1,Nx-1]);
    V2 = ones([1,Nx-2]);
    V3 = ones([1,Nx-3]);
    V4 = ones([1,Nx-4]);
    V5 = ones([1,Nx-5]);
    A = diag(V1,-1) + diag(3*V0,0) + diag(V1,+1);
    B = (diag(-1/12*V2,-2) + diag(-7/3*V1,-1) + diag(7/3*V1,+1) + diag(1/12*V2,+2))/dx;

    if (PeriodicFlag == 0)
      % boundary terms
      alpha  = 2;
      a      = -(11.0 + 2.0*alpha)/6.0;
      b      = (6.0 - alpha)/2.0;
      c      = (2.0*alpha - 3.0)/2.0;
      d      = (2.0 - alpha)/6.0;
      A(1,:) = [1 alpha 0*V2];
      B(1,:) = [a b c d 0*V4]/dx;
      A(2,:) = [1 4 1 0*V3];
      B(2,:) = [-3 0 3 0*V3]/dx;
      A(end-1,:) = [0*V3 1 4 1];
      B(end-1,:) = [0*V3 -3 0 3]/dx;
      A(end,:) = [0*V2 alpha 1];
      B(end,:) = [0*V4 -d -c -b -a]/dx;
    else
      % periodic
      A(1,:) = [3 1 0*V3 1];
      B(1,:) = [0 7/3 1/12 0*V5 -1/12 -7/3]/dx;
      A(2,:) = [1 3 1 0*V3];
      B(2,:) = [-7/3 0 7/3 1/12 0*V5 -1/12]/dx;
      A(end-1,:) = [0*V3 1 3 1];
      A(end,:) = [1 0*V3 1 3];
      B(end-1,:) = [1/12 0*V5 -1/12 -7/3 0 7/3]/dx;
      B(end,:)   = [7/3 1/12 0*V5 -1/12 -7/3 0]/dx;
    end

    D = inv(A)*B;

    return;
end
%% Central 2
function D = Central2(Nx,dx,PeriodicFlag)
%
% [D] = Central2(Nx,dx,PeriodicFlag)
%
% Return the inv(A)*B matrix for the 3-4-6 Pade scheme on a grid
% of Nx points with equal spacing dx.
%
% INPUTS:
%
% PeriodicFlag = 1 = TRUE;
% PeriodicFlag = 0 = FALSE;
%
% OUTPUTS:
%
% D     = inv(A)*B
% kmax  = maximum wavenumber
% kstar = maximum wavenumber for a given accuracy
%

fprintf(1,'Using 2nd-order central ');
V1 = ones([1,Nx-1]);
V2 = ones([1,Nx-2]);
V3 = ones([1,Nx-3]);
B = (-diag(V1,-1)+diag(V1,1))/(2*dx);
if (PeriodicFlag == 0)
  % boundary terms
  fprintf(1,'bounded.\n');
  B(1,:) = [-1 1 0*V2]/dx;
  B(Nx,:) = [0*V2 -1 1]/dx;
else
  fprintf(1,'periodic.\n');
  B(1,:) = [0 1 0*V3 -1]/(2*dx);
  B(Nx,:) = [1 0*V3 -1 0]/(2*dx);
end
D = B;
return;
end
%% Upwind Biased (3)
function D = UpwindBiased3(Nx,dx,PeriodicFlag)
    %
    % [C] = Central2(Nx,dx,PeriodicFlag)
    %
    % Return the inv(A)*B matrix for the 3-4-6 Pade scheme on a grid
    % of Nx points with equal spacing dx.
    %
    % INPUTS:
    %
    % PeriodicFlag = 1 = TRUE;
    % PeriodicFlag = 0 = FALSE;
    %
    % OUTPUTS:
    %
    % C     = inv(A)*B
    % kmax  = maximum wavenumber
    % kstar = maximum wavenumber for a given accuracy
    %

    fprintf(1,'Using 3rd-order upwind ');

    V0 = ones([1,Nx]);
    V1 = ones([1,Nx-1]);
    V2 = ones([1,Nx-2]);
    V3 = ones([1,Nx-3]);
    V4 = ones([1,Nx-4]);

    B = (diag(V2,-2)-6*diag(V1,-1)+3*diag(V0,0)+2*diag(V1,+1))/(6*dx);

    if (PeriodicFlag == 0)
      % boundary terms
      error('No boundary stencil implemented.')
    else
      fprintf(1,'periodic.\n');
      B(1,:)  = [3 2 0*V4 1 -6]/(6*dx);
      B(2,:)  = [-6 3 2 0*V4 1]/(6*dx);
      B(Nx,:) = [2 0*V4 1 -6 3]/(6*dx);
    end

    D = B;

    return;
end
%% Downwind Biased (3)
function D = DownwindBiased3(Nx,dx,PeriodicFlag)
    %
    % [D] = Central2(Nx,dx,PeriodicFlag)
    %
    % Return the inv(A)*B matrix for the 3-4-6 Pade scheme on a grid
    % of Nx points with equal spacing dx.
    %
    % INPUTS:
    %
    % PeriodicFlag = 1 = TRUE;
    % PeriodicFlag = 0 = FALSE;
    %
    % OUTPUTS:
    %
    % C     = inv(A)*B
    % kmax  = maximum wavenumber
    % kstar = maximum wavenumber for a given accuracy
    %

    fprintf(1,'Using 3rd-order downwind ');

    V0 = ones([1,Nx]);
    V1 = ones([1,Nx-1]);
    V2 = ones([1,Nx-2]);
    V3 = ones([1,Nx-3]);
    V4 = ones([1,Nx-4]);

    B = (-2*diag(V1,-1)-3*diag(V0,0)+6*diag(V1,1)-1*diag(V2,+2))/(6*dx);

    if (PeriodicFlag == 0)
      % boundary terms
      error('No boundary stencil implemented.')
    else
      fprintf(1,'periodic.\n');
      B(1,:)    = [-3 6 -1 0*V4 -2]/(6*dx);
      B(Nx-1,:) = [-1 0*V4 -2 -3 6]/(6*dx);
      B(Nx,:)   = [6 -1 0*V4 -2 -3]/(6*dx);
    end

    D = B;

    return;
end
%% HW1 - a
function D = First(Nx,dx)
% Periodic domain, returns the D matrix for the derivative from 1a

a=zeros([5 1]);
a(1)=1/12;
a(2)=-2/3;
a(3)=0;
a(4)=2/3;
a(5)=-1/12;

r=[a(3) a(4) a(5) zeros([1 Nx-5]) a(1) a(2) ];
M = zeros(Nx,Nx);
for i=1:Nx
    M(i,:) = r;
    r = circshift(r,1);
end
M = M * (1/dx);
D = M;
return;
end
%% HW1 - b
function D = Second(Nx,dx)
% Periodic domain, calculated the D matrix for the derivative from 1b
a = zeros([4 1]);
a(1) = 1/6;
a(2) = -1;
a(3) = 1/2;
a(4) = 1/3;

r = [a(3) a(4) zeros([1 Nx-4]) a(1) a(2)];
M = zeros(Nx,Nx);
for i=1:Nx
    M(i,:) = r;
    r = circshift(r,1);
end
M = M * (1/dx);
D = M;
return;
end
%% HW1 - c
function D = Third(Nx,dx)
% Implicit FD, use the Pade scheme approximation

al = 1/3;

a = zeros([5 1]);
a(1) = -(4*al-1)/12;
a(2) = -(al+2)*4/12;
a(3) = 0;
a(4) = (al+2)*4/12;
a(5) = (4*al-1)/12;

r1 = [a(3) a(4) a(5) zeros([1 Nx-5]) a(1) a(2) ];
r2 = [1 al zeros([1 Nx-3]) al ];
A = zeros(Nx,Nx);
B = zeros(Nx,Nx);

for i=1:Nx
    B(i,:) = r1;
    r1 = circshift(r1,1);
    A(i,:) = r2;
    r2 = circshift(r2,1);
end
B = B * (1/dx);
M = inv(A)*B;
D = M;
return;
end
