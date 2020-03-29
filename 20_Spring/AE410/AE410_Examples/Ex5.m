% Ex5.m ... injection BC tests on scalar advection

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
PeriodicFlag = 0;

% construct operator
D2c = sparse(Central2(Nx,dx,PeriodicFlag));
D3u = sparse(UpwindBiased3(Nx,dx,PeriodicFlag));
D4c = Pade346(Nx,dx,PeriodicFlag);

% boundary operator
B = eye(Nx); B(1,1) = 0;

% solve ODE using first non-constant eigenvector as IC
u0 = exp(-(x-0.5).^2/0.1^2);
t0 = linspace(0,50,1000);
options = odeset('AbsTol',1e-10);
[t,u2c] = ode45(@(t,y) advODE(t,y,B*D2c),t0,u0,options);
[t,u3u] = ode45(@(t,y) advODE(t,y,B*D3u),t0,u0,options);
[t,u4c] = ode45(@(t,y) advODE(t,y,B*D4c),t0,u0,options);
for n = 1:1:100
    figure(1)
    plot(x,u2c(n,:),'b-o')
    axis([-0.1 1.1 -0.5 1.5]);
    xlabel('x');
    ylabel('u');
    title('2nd order central FD');
%     figure(2)
%     plot(x,u3u(n,:),'b-o')
%     axis([-0.1 1.1 -0.5 1.5]);
%     xlabel('x');
%     ylabel('u');
%     title('3rd order upwind FD');
%     figure(3)
%     plot(x,u4c(n,:),'b-o')
%     axis([-0.1 1.1 -0.5 1.5]);
%     xlabel('x');
%     ylabel('u');
%     title('3-4-6 compact FD');
     pause(0.1)
end
% figure(4);
% loglog(t,trapz(x,u2c.^2,2),t,trapz(x,u3u.^2,2),t,trapz(x,u4c.^2,2));
% xlabel('t');
% ylabel('energy');
% legend('2nd order central','3rd order upwind','3-4-6 compact central','Location','SouthWest');