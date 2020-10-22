% Ex8 --- exact solution for q1d problem adopted from Hirsch v2 p. 221
%
%
set(0,'defaultaxesfontname','times');
set(0,'defaultaxesfontsize',20);

Astar = 1.0; % Hirsch has 0.8 in book, but figures correspond to 1.0;
gamma = 1.4;
xs    = 4.0; % shock location 
R     = 287.04;

[x,A,rho,u,p,M] = ExactSolution(gamma,R,xs,Astar);
T  = p ./ (R * rho);
pt = p .* (1 + (gamma-1)/2*M.^2).^(gamma/(gamma-1));
Tt = T .* (1 + (gamma-1)/2*M.^2);
ds = - R * log(pt./pt(1));
Ashock = interp1(x,A,xs);

figure(1), clf;
subplot(4,2,1); plot(x,A,'k-'); line([xs xs],[0 interp1(x,A,xs)]); xlabel('x'); ylabel('Area [m^2]');
subplot(4,2,2); plot(x,M); xlabel('x'); ylabel('M');
subplot(4,2,3); plot(x,p/1e5); xlabel('x'); ylabel('P [bar]');
subplot(4,2,4); plot(x,rho); xlabel('x'); ylabel('\rho [kg/m^3]');
subplot(4,2,5); plot(x,rho.*u.*A); xlabel('x'); ylabel('mdot = \rho u A [kg/s]');
subplot(4,2,6); plot(x,ds); xlabel('x'); ylabel('Entropy [J/(kg.K)]');
subplot(4,2,7); plot(x,Tt); xlabel('x'); ylabel('Total temperature [K]');
subplot(4,2,8); plot(x,pt/1e5); xlabel('x'); ylabel('Total pressure [bar]');