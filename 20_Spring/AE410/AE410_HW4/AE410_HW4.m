clear all;
close all;
clc;
figID = 1;
%% Problem 2
% Define integrator inputs
L = 1;
Nx = 51;
T = 10;
Nt = 11;
PeriodicFlag = 1;
casedef = 'LinearAdvection';

% Define the initial condition
syms x_s real
u0 = exp((-(x_s-0.5).^2)/(0.1^2));

% Run the integrator
[t1, u1] = integrator(L, Nx, PeriodicFlag, T, Nt, u0, 'First', casedef);
[t2, u2] = integrator(L, Nx, PeriodicFlag, T, Nt, u0, 'Second', casedef);
[t3, u3] = integrator(L, Nx, PeriodicFlag, T, Nt, u0, 'Third', casedef);

% u(x,t) = F(x) * (x - alpha*t)
% du/dt =~ D*u --> u(x,t) =~ 1/2*D*u^2

% Solve for matrix operators
dx = L/Nx;
x = dx*linspace(0,Nx-1,Nx).';
D1 = sparse(First(Nx, dx));
D2 = sparse(Second(Nx, dx));
D3 = sparse(Third(Nx, dx));

% Solve equation approximately using schemes
f1 = 0.5*D1*(u1.^2)';
f2 = 0.5*D2*(u2.^2)';
f3 = 0.5*D3*(u3.^2)';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot the analytical approximation against exact solution 
figure(figID); figID = figID + 1; clf;
sgtitle('P2 - Numerical Approximation 1a-1c', 'Fontsize', 24)
for p = 1:10
    subplot(2,5,p)
    t_i = p;
    f1_i = f1(:,p);
    f2_i = f2(:,p);
    f3_i = f3(:,p);
    hold on
    grid on
    plot(x, f1_i, 'b-', 'Linewidth', .75)
    plot(x, f2_i, 'r-', 'Linewidth', .75)
    plot(x, f3_i, 'g-', 'Linewidth', .75)
    xlabel('$x$', 'interpreter', 'latex', 'fontsize', 16)
    ylabel('$u$', 'interpreter', 'latex', 'fontsize', 16)
    title(sprintf('t = %.15g s',t_i))
    legend({'1a'; '1b'; '1c'},'location','southoutside','orientation','horizontal','fontsize',12)
    hold off
end
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
print( '-dpng', 'P2_solutions', '-r150' )

% Plot the eigenvalue spectra of D matrices
[V1,De1,W1] = eigs(D1);
[V2,De2,W2] = eigs(D2);
[V3,De3,W3] = eigs(D3);
figure(figID); figID = figID + 1; clf;
plot(real(diag(De1)),imag(diag(De1)),'bo','markersize',4), hold on;
plot(real(diag(De2)),imag(diag(De2)),'ro','markersize',4)
plot(real(diag(De3)),imag(diag(De3)),'go','markersize',4)
legend({'1a','1b','1c'}, 'location','best');
xlabel('$\lambda_{real}$', 'interpreter', 'latex', 'fontsize', 16)
ylabel('$\lambda_{imag}$', 'interpreter', 'latex', 'fontsize', 16)
title('P2 - Eigenvalues of Numeric Matrices')
set(gcf,'Position',[100 100 800 800])
print( '-dpng', 'P2_eigenvalues', '-r150' )

%% Problem 3
% Define integrator inputs
L = 1;
Nx = 51;
T = 10;
Nt = 11;
PeriodicFlag = 1;
casedef = 'ConservativeBurgers';

% Define the initial condition
syms x_s real
u0 = exp((-(x_s-0.5).^2)/(0.1^2));

% Run the integrator
[t1, u1] = integrator(L, Nx, PeriodicFlag, T, Nt, u0, 'First', casedef);
[t2, u2] = integrator(L, Nx, PeriodicFlag, T, Nt, u0, 'Second', casedef);
[t3, u3] = integrator(L, Nx, PeriodicFlag, T, Nt, u0, 'Third', casedef);

% u(x,t) = u0(x,0) * (x - alpha*t)
% du/dt =~ D*u --> u(x,t) =~ 1/2*D*u^2

% Solve for matrix operators
dx = L/Nx;
x = dx*linspace(0,Nx-1,Nx).';
D1 = sparse(First(Nx, dx));
D2 = sparse(Second(Nx, dx));
D3 = sparse(Third(Nx, dx));

% Solve equation approximately using schemes
f1 = 0.5*D1*(u1.^2)';
f2 = 0.5*D2*(u2.^2)';
f3 = 0.5*D3*(u3.^2)';

% Solve equation exactly
syms x_s t_s
f = -0.5*x_s^2;
alpha = 1;
f_exact = subs(u0, x_s, x) .* (x - alpha*t_s);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot the analytical approximation against exact solution 
figure(figID); figID = figID + 1; clf;
sgtitle('P3 - Numerical Approximation Burgers', 'Fontsize', 24)
for p = 1:10
    subplot(2,5,p)
    t_i = p;
    f1_i = f1(:,p);
    f2_i = f2(:,p);
    %f3_i = f3(:,p);
    hold on
    grid on
    plot(x, f1_i, 'b-', 'Linewidth', .75)
    plot(x, f2_i, 'r-', 'Linewidth', .75)
    %plot(x, f3_i, 'g-', 'Linewidth', .75)
    plot(x, subs(f_exact,t_s,t_i), 'k-', 'Linewidth', .75)
    xlabel('$x$', 'interpreter', 'latex', 'fontsize', 16)
    ylabel('$u$', 'interpreter', 'latex', 'fontsize', 16)
    title(sprintf('t = %.15g s',t_i))
    legend({'1a'; '1b'; 'exact'},'location','southoutside','orientation','horizontal','fontsize',12)
    hold off
end
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
print( '-dpng', 'P3_solutions', '-r150' )

% Plot the eigenvalue spectra of D matrices
[V1,De1,W1] = eigs(D1);
[V2,De2,W2] = eigs(D2);
[V3,De3,W3] = eigs(D3);
figure(figID); figID = figID + 1; clf;
plot(real(diag(De1)),imag(diag(De1)),'bo','markersize',4), hold on;
plot(real(diag(De2)),imag(diag(De2)),'ro','markersize',4)
plot(real(diag(De3)),imag(diag(De3)),'go','markersize',4)
legend({'1a','1b','1c'}, 'location','best');
xlabel('$\lambda_{real}$', 'interpreter', 'latex', 'fontsize', 16)
ylabel('$\lambda_{imag}$', 'interpreter', 'latex', 'fontsize', 16)
title('P3 - Eigenvalues of Numeric Matrices')
set(gcf,'Position',[100 100 800 800])
print( '-dpng', 'P3_eigenvalues', '-r150' )

%% Problem 4
% Define integrator inputs
L = 1;
Nx = 51;
T = 10;
Nt = 11;
PeriodicFlag = 1;
casedef = 'LinearAdvection';

% Define the initial condition
syms x_s real
u0 = exp((-(x_s-0.5).^2)/(0.1^2));

% Run the integrator
[t1, u1] = integrator(L, Nx, PeriodicFlag, T, Nt, u0, 'First', casedef);
[t2, u2] = integrator(L, Nx, PeriodicFlag, T, Nt, u0, 'Second', casedef);
[t3, u3] = integrator(L, Nx, PeriodicFlag, T, Nt, u0, 'Third', casedef);

% u(x,t) = F(x) * (x - alpha*t)
% du/dt =~ D*u --> u(x,t) =~ 1/2*D*u^2

% Solve for matrix operators
dx = L/Nx;
x = dx*linspace(0,Nx-1,Nx).';
D1 = sparse(First(Nx, dx));
D2 = sparse(Second(Nx, dx));
D3 = sparse(Third(Nx, dx));

% Solve equation approximately using schemes
f1 = (0.5*D1.*D1*(u1.^2)');
f2 = (0.5*D2.*D2*(u2.^2)');
f3 = (0.5*D3.*D3*(u3.^2)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot the analytical approximation against exact solution 
figure(figID); figID = figID + 1; clf;
sgtitle('P4 - Numerical Approximation 1a-1c', 'Fontsize', 24)
for p = 1:10
    subplot(2,5,p)
    t_i = p;
    f1_i = f1(:,p);
    f2_i = f2(:,p);
    f3_i = f3(:,p);
    hold on
    grid on
    plot(x, f1_i, 'b-', 'Linewidth', .75)
    plot(x, f2_i, 'r-', 'Linewidth', .75)
    plot(x, f3_i, 'g-', 'Linewidth', .75)
    xlabel('$x$', 'interpreter', 'latex', 'fontsize', 16)
    ylabel('$u$', 'interpreter', 'latex', 'fontsize', 16)
    title(sprintf('t = %.15g s',t_i))
    legend({'1a'; '1b'; '1c'},'location','southoutside','orientation','horizontal','fontsize',12)
    hold off
end
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
print( '-dpng', 'P4_solutions', '-r150' )

% Plot the eigenvalue spectra of D matrices
[V1,De1,W1] = eigs(D1);
[V2,De2,W2] = eigs(D2);
[V3,De3,W3] = eigs(D3);
figure(figID); figID = figID + 1; clf;
plot(real(diag(De1)),imag(diag(De1)),'bo','markersize',4), hold on;
plot(real(diag(De2)),imag(diag(De2)),'ro','markersize',4)
plot(real(diag(De3)),imag(diag(De3)),'go','markersize',4)
legend({'1a','1b','1c'}, 'location','best');
xlabel('$\lambda_{real}$', 'interpreter', 'latex', 'fontsize', 16)
ylabel('$\lambda_{imag}$', 'interpreter', 'latex', 'fontsize', 16)
title('P4 - Eigenvalues of Numeric Matrices')
set(gcf,'Position',[100 100 800 800])
print( '-dpng', 'P4_eigenvalues', '-r150' )

%% Problem 5
% Define integrator inputs
L = 1;
Nx = 51;
T = 10;
Nt = 11;
PeriodicFlag = 1;
casedef = 'LinearAdvection';

% Define the initial condition
syms x_s real
u0 = exp((-(x_s-0.5).^2)/(0.1^2));

% Run the integrator
[t1, u1] = integrator(L, Nx, PeriodicFlag, T, Nt, u0, 'First', casedef);
[t2, u2] = integrator(L, Nx, PeriodicFlag, T, Nt, u0, 'Second', casedef);
[t3, u3] = integrator(L, Nx, PeriodicFlag, T, Nt, u0, 'Third', casedef);

% u(x,t) = F(x) * (x - alpha*t)
% du/dt =~ D*u --> u(x,t) =~ 1/2*D*u^2

% Solve for matrix operators
dx = L/Nx;
x = dx*linspace(0,Nx-1,Nx).';
D1 = sparse(First(Nx, dx));
D2 = sparse(Second(Nx, dx));
D3 = sparse(Third(Nx, dx));

% Solve equation approximately using schemes
f1 = -(0.5*D1.*D1*(u1.^2)');
f2 = -(0.5*D2.*D1*(u2.^2)');
f3 = -(0.5*D3.*D3*(u3.^2)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot the analytical approximation against exact solution 
figure(figID); figID = figID + 1; clf;
sgtitle('P5 - Numerical Approximation 1a-1c', 'Fontsize', 24)
for p = 1:10
    subplot(2,5,p)
    t_i = p;
    f1_i = f1(:,p);
    f2_i = f2(:,p);
    f3_i = f3(:,p);
    hold on
    grid on
    plot(x, f1_i, 'b-', 'Linewidth', .75)
    plot(x, f2_i, 'r-', 'Linewidth', .75)
    plot(x, f3_i, 'g-', 'Linewidth', .75)
    xlabel('$x$', 'interpreter', 'latex', 'fontsize', 16)
    ylabel('$u$', 'interpreter', 'latex', 'fontsize', 16)
    title(sprintf('t = %.15g s',t_i))
    legend({'1a'; '1b'; '1c'},'location','southoutside','orientation','horizontal','fontsize',12)
    hold off
end
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
print( '-dpng', 'P5_solutions', '-r150' )

% Plot the eigenvalue spectra of D matrices
[V1,De1,W1] = eigs(D1);
[V2,De2,W2] = eigs(D2);
[V3,De3,W3] = eigs(D3);
figure(figID); figID = figID + 1; clf;
plot(real(diag(De1)),imag(diag(De1)),'bo','markersize',4), hold on;
plot(real(diag(De2)),imag(diag(De2)),'ro','markersize',4)
plot(real(diag(De3)),imag(diag(De3)),'go','markersize',4)
legend({'1a','1b','1c'}, 'location','best');
xlabel('$\lambda_{real}$', 'interpreter', 'latex', 'fontsize', 16)
ylabel('$\lambda_{imag}$', 'interpreter', 'latex', 'fontsize', 16)
title('P5 - Eigenvalues of Numeric Matrices')
set(gcf,'Position',[100 100 800 800])
print( '-dpng', 'P5_eigenvalues', '-r150' )

%% Problem 1
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
    elseif strcmpi('Pade346', spacedef)
        D1 = sparse(Pade346(Nx, dx));
    elseif strcmpi('UpwindBiased3', spacedef)
        D1 = sparse(UpwindBiased3(Nx, dx, PeriodicFlag));
    elseif strcmpi('DownBiased3', spacedef)
        D1 = sparse(DownBiased3(Nx, dx, PeriodicFlag));
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
    options = odeset('AbsTol',1e-10);
    if strcmpi('LinearAdvection', casedef)
        [t,u] = ode45(@(t,y) LinearAdvection(t,y,D1), t, u0, options);
    elseif strcmpi('ConservativeBurgers', casedef)
        [t,u] = ode45(@(t,y) ConservativeBurgers(t,y,D1), t, u0, options);
    elseif strcmpi('AdvectionODE', casedef)
        % boundary operator
        B = eye(Nx); B(1,1) = 0;
        [t,u] = ode45(@(t,y) advODE(t,y,B*D1), t, u0, options);
    elseif strcmpi('EulerODE', casedef)    
        % initial condition for Euler
        rref = 1.225;       % total density
        pref = 1.01325e5;   % total pressure
        g    = 1.4;         % gamma
        R    = 286.9;       % Temp in rankine
        cref = sqrt(g*pref/rref);   % Speed of sound
        rho0 = rref * ones([Nx 1]); % INitial Density Condition
        u0   = 0    * ones([Nx 1]); % initial Condition
        p0   = pref * ones([Nx 1]); % Initial Pressure Condition
        q0   = [rho0; u0; p0];      % Initial matrix
        [t,u] = ode45(@(t,y) EulerODE(t,y,D1), t, q0, options);
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
%% Advection ODE
function udot = advODE(t, u, D)
    udot = -D * u;
    return;
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
