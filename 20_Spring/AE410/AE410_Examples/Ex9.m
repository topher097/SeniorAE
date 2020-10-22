% Ex9 --- FV solution for q1d problem adopted from Hirsch v2 p. 221
%
%
set(0,'defaultaxesfontname','times');
set(0,'defaultaxesfontsize',20);

% problem parameters
Astar = 1.0; % Hirsch has 0.8 in book, but his figures correspond to 1.0;
gamma = 1.4;
xs    = 5.0; % shock location (use minus for all subsonic)
R     = 286.9;
Nx    = 101;

% exact solution
[xe,Ae,dAe,rhoe,ue,pe,Me] = ExactSolution(gamma,R,xs,Astar,Nx);
Te  = pe ./ (R * rhoe);
pte = pe .* (1 + (gamma-1)/2*Me.^2).^(gamma/(gamma-1));
Tte = Te .* (1 + (gamma-1)/2*Me.^2);
dse = - R * log(pte./pte(1));
Ashock = interp1(xe,Ae,xs);

% FV solution
% specify initial conditions for the variables [rho, rho u, rho E]
q0 = [rhoe; rhoe .* ue; pe/(gamma-1) + 0.5 * rhoe .* ue .* ue];
t0 = [0 1e-2];

% time integrate
[t,q] = ode45(@(t,y) EulerFV(t,y,gamma,xe,Ae,dAe), t0, q0);

% make movie of field
figure(1), clf
size(q)
for n = 1:min(100,length(t))
    subplot(3,1,1), plot(xe,q(n,1:Nx));
    subplot(3,1,2), plot(xe,q(n,Nx+1:2*Nx));
    subplot(3,1,3), plot(xe,q(n,2*Nx+1:3*Nx));
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

figure(2), clf;
subplot(4,2,1); plot(xe,Ae,'k-'); line([xs xs],[0 interp1(xe,Ae,xs)]); xlabel('x'); ylabel('Area [m^2]');
axis([0 10 1 2]);
subplot(4,2,2); plot(xe,Me,xe,M); xlabel('x'); ylabel('M');
subplot(4,2,3); plot(xe,pe/101325,xe,p/101325); xlabel('x'); ylabel('P [bar]');
subplot(4,2,4); plot(xe,rhoe,xe,rho); xlabel('x'); ylabel('\rho [kg/m^3]');
subplot(4,2,5); plot(xe,rhoe.*ue.*Ae,xe,rho.*u.*Ae.'); xlabel('x'); ylabel('mdot = \rho u A [kg/s]');
subplot(4,2,6); plot(xe,dse,xe,ds); xlabel('x'); ylabel('Entropy [J/(kg.K)]');
subplot(4,2,7); plot(xe,Tte,xe,Tt); xlabel('x'); ylabel('Total temperature [K]');
subplot(4,2,8); plot(xe,pte/101325,xe,pt/101325); xlabel('x'); ylabel('Total pressure [bar]');