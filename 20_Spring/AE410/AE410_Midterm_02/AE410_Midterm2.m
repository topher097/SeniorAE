%% AE410 Midterm 2
% Author: Christopher Endres
% Date: 5/4/2020
clc;
clear all;
close all;
figID = 1;


%% Problem 2
X = [1  0   0;...
     0  1   0;...
     0  0   1];

 % Define integrator inputs
L = 1;
Nx = 51;
T = 0.01;
Nt = 11;
PeriodicFlag = 1;
casedef = 'LinearAdvection';

% Define the initial condition
syms x_s real
u0 = x_s;

% Run the integrator
[t1, u1] = integrator(L, Nx, PeriodicFlag, T, Nt, u0, 'First', casedef);

% Solve for matrix operators
dx = L/Nx;
x = dx*linspace(0,Nx-1,Nx).';
D1 = sparse(First(Nx, dx));
D1 = sparse(X);

% Solve equation approximately using schemes
f1 = 0.5*D1*(u1.^2)';

% Plot the analytical approximation against exact solution 
figure(figID); figID = figID + 1; clf;
sgtitle('P2 - Numerical Approximation 1a-1c', 'Fontsize', 24)
for p = 1:10
    subplot(2,5,p)
    t_i = p;
    f1_i = f1(:,p);
    hold on
    grid on
    plot(x, f1_i, 'b-', 'Linewidth', .75)
    xlabel('$x$', 'interpreter', 'latex', 'fontsize', 16)
    ylabel('$u$', 'interpreter', 'latex', 'fontsize', 16)
    title(sprintf('t = %.15g s',t_i))
    legend({'1a'},'location','southoutside','orientation','horizontal','fontsize',12)
    hold off
end
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
print( '-dpng', 'P2_solutions', '-r150' )

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
%% Linear Advection
function udot = LinearAdvection(t, u, D)
    udot = -D * u;
    return
end