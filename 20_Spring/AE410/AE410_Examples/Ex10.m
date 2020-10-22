% Ex10 --- Euler solution for Euler problem adopted from Hirsch v2 p. 221
%
%
set(0,'defaultaxesfontname','times');
set(0,'defaultaxesfontsize',20);

% problem parameters
gamma = 1.4;
R     = 286.9; % J/(kg.K)
Nx    = 101;
x     = linspace(-1,1,Nx);

% specify initial conditions for the variables [rho, rho u, rho E]
% left state
pL   = 4*101325;
TL   = 300;
uL   = 0.0;
rhoL = pL/(R*TL);
% right state
pR   = 101325;
TR   = 300;
uR   = 0.0;
rhoR = pR/(R*TR);
% combined state
rho = zeros(Nx,1); iL = find(x<0); iR = find(x>=0);
u   = zeros(Nx,1);
p   = zeros(Nx,1);
rho(iL) = rhoL; rho(iR) = rhoR;
u(iL) = uL; u(iR) = uR;
p(iL) = pL; p(iR) = pR;
q0 = [rho; rho .* u; p/(gamma-1) + 0.5 * rho .* u .* u];
t0 = [0 1e-2];
return

% time integrate
[t,q] = ode45(@(t,y) EulerGodunov(t,y,gamma,Nx), t0, q0);

% make movie of field
figure(1), clf
size(q)
for n = 1:min(100,length(t))
    subplot(3,1,1), plot(x,q(n,1:Nx));
    subplot(3,1,2), plot(x,q(n,Nx+1:2*Nx));
    subplot(3,1,3), plot(x,q(n,2*Nx+1:3*Nx));
    pause(0.1);
end

% extract 'final' solutions
rho  = q(end,1:Nx);
u    = q(end,Nx+1:2*Nx) ./ rho;
p    = (gamma-1)*(q(end,2*Nx+1:3*Nx) - 0.5 * rho .* u .* u);
M    = u ./ sqrt(gamma * p ./ rho);
T    = p ./ (R * rho);
pt   = p .* (1 + (gamma-1)/2*M.^2).^(gamma/(gamma-1));
Tt   = T .* (1 + (gamma-1)/2*M.^2);
ds   = - R * log(pt./pt(1));