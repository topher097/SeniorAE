% Ex7.m ... 1-D Euler Equations

% clean up
clear all
% close all

% default plot attributes
set(0,'defaultaxesfontname','times');
set(0,'defaultaxesfontsize',20);
figID = 1;
Nx = 51;
L  = 1;
dx = L/(Nx-1);
x  = dx*linspace(0,Nx-1,Nx).';
PeriodicFlag = 0;

% construct derivative operators
[D2c,D2c2] = (Central2(Nx,dx,PeriodicFlag));
D2c = sparse(D2c); D2c2 = sparse(D2c2);
D3p = sparse(UpwindBiased3(Nx,dx,PeriodicFlag));
D3m = sparse(DownwindBiased3(Nx,dx,PeriodicFlag));
D4c = Pade346(Nx,dx,PeriodicFlag);

% initial condition
rref = 1.225;
pref = 1.01325e5;
g    = 1.4;
R    = 286.9;
cref = sqrt(g*pref/rref);
rho0 = rref * ones([Nx 1]);
u0   = 0    * ones([Nx 1]);
p0   = pref * ones([Nx 1]);
q0   = [rho0; u0; p0];

% time vector
t0 = linspace(0,1e-1,100);

% artificial dissipation parameter
eps = 1e+4 * dx * dx;

% solve ODE
[t,u2c] = ode45(@(t,y) EulerODE(t,y,D2c,D2c2,eps),t0,q0);
[t,u3u] = ode45(@(t,y) EulerODEChar(t,y,D3p,D3m),t0,q0);
[t,u4c] = ode45(@(t,y) EulerODE(t,y,D4c,D2c2,eps),t0,q0);
for n = 1:1:100
    
    % 2nd order FD
%     rho = u2c(n,1:Nx);
%     u   = u2c(n,(Nx+1):(2*Nx));
%     p   = u2c(n,(2*Nx+1):(3*Nx));
%     c   = sqrt(g*p./rho);
%     M   = abs(u)./c;
%     pt  = p .* (1+(g-1)/2*M.*M).^(g/(g-1));
%     figure(1), clf, subplot(2,1,1)
%     plot(x,rho/rref,'b-o'); hold on;
%     plot(x,u./c,'r-s')
%     plot(x,p/pref,'k-d');
%     axis([-0.1 1.1 -0.5 1.5]);
%     xlabel('x');
%     ylabel('\rho/\rho_{ref}, M, p/p_{ref}');
%     title('2nd order central FD (with artificial dissipation)');
%     subplot(2,1,2)
%     plot(x,pt/pref);
%     axis([-0.1 1.1 -0.5 1.5]);
%     xlabel('x');
%     ylabel('p_t/p_{ref}');
%     
    % 3rd order upwind
    rho = u3u(n,1:Nx);
    u   = u3u(n,(Nx+1):(2*Nx));
    p   = u3u(n,(2*Nx+1):(3*Nx));
    c   = sqrt(g*p./rho);
    M   = abs(u)./c;
    pt  = p .* (1+(g-1)/2*M.*M).^(g/(g-1));
    figure(2), clf, subplot(2,1,1)
    plot(x,rho/rref,'b-o'); hold on;
    plot(x,u./c,'r-s')
    plot(x,p/pref,'k-d');
    axis([-0.1 1.1 -0.5 1.5]);
    xlabel('x');
    ylabel('\rho/\rho_{ref}, M, p/p_{ref}');
    title('3rd order upwind FD (with A^+, A^- splitting)');
    subplot(2,1,2)
    plot(x,pt/pref);
    axis([-0.1 1.1 -0.5 1.5]);
    xlabel('x');
    ylabel('p_t/p_{ref}');
    
%     % 4th order central
%     rho = u4c(n,1:Nx);
%     u   = u4c(n,(Nx+1):(2*Nx));
%     p   = u4c(n,(2*Nx+1):(3*Nx));
%     c   = sqrt(g*p./rho);
%     M   = abs(u)./c;
%     pt  = p .* (1+(g-1)/2*M.*M).^(g/(g-1));
%     figure(3), clf, subplot(2,1,1)
%     plot(x,rho/rref,'b-o'); hold on;
%     plot(x,u./c,'r-s')
%     plot(x,p/pref,'k-d');
%     axis([-0.1 1.1 -0.5 1.5]);
%     xlabel('x');
%     ylabel('\rho/\rho_{ref}, M, p/p_{ref}');
%     title('4th order central FD (with artificial dissipation)');
%     subplot(2,1,2)
%     plot(x,pt/pref);
%     axis([-0.1 1.1 -0.5 1.5]);
%     xlabel('x');
%     ylabel('p_t/p_{ref}');
    
    pause(0.05)
end