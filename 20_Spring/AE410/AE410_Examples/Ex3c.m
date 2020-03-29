% Ex3c.m ... 2nd order upwind finite difference example on periodic
% conservative Burgers equation

% clean up
clear all
% close all

% default plot attributes
set(0,'defaultaxesfontname','times');
set(0,'defaultaxesfontsize',20);
figID = 1;
Nx = 51;
L  = 1;
dx = L/Nx;
x  = dx*linspace(0,Nx-1,Nx).';
PeriodicFlag = 1;

% construct operator
D1 = Central2(Nx,dx,PeriodicFlag);

% solve ODE using first non-constant eigenvector as IC
u0 = 1+exp(-(x-0.5).^2/0.1^2);
[t,u1] = ode45(@(t,y) conservativeBurgers(t,y,D1),linspace(0,1,100),u0);
[t,u2] = ode45(@(t,y) advODE(t,y,D1),linspace(0,1,100),u0);
for n = 1:length(t)
    figure(1)
    plot(x,u1(n,:),'b-o',x,u2(n,:),'r-s')
    axis([-0.1 1.1 0.5 2.5]);
    pause(0.1)
    if (n == 1)
        xlabel('x');
        ylabel('u');
    end
    figure(2)
    % plot the eigenvalues of D
    [V,D] = eig(diag(u2(n,:))*D1);
    %plot(real(diag(D)),imag(diag(D)),'bo');
    axis([-10 10 -100 100]);
    xlabel('Real\{\lambda\}')
    ylabel('Imag\{\lambda\}')
end
xlabel('x');
ylabel('u');