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

%% Propblem 1
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
