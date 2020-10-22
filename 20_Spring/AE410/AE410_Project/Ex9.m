% Ex9 --- FV solution for q1d problem adopted from Hirsch v2 p. 221
%
%
clc;
clear all;
close all;

set(0,'defaultaxesfontname','times');
set(0,'defaultaxesfontsize',20);

% problem parameters
L = 10;
Astar = 1.0; % Hirsch has 0.8 in book, but his figures correspond to 1.0;
gamma = 1.4;
xs    = 5.0; % shock location (use minus for all subsonic)
R     = 286.9;
Nx    = 101;
M_guess = 1.5;
M_guess_shock = 1.5;
x = linspace(0,L,Nx);



% exact solution
[xe,Ae,dAe,rhoe,ue,pe,Me] = ExactSolution(gamma,R,xs,Astar,L,Nx,M_guess_shock,M_guess);
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
%[t,q] = ode45(@(t,y) FluxRHS1D(t,y,x,L,Nx,gamma), t0, q0);

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


%% Exact Solution function
function [x,A,dA,rho,u,p,M] = ExactSolution(g,R,xs,Astar,L,Nx,M_guess_shock,M_guess)
    % domain
    x = linspace(0,L,Nx).';

    % area
    [A,dA] = Area(x);

    % initialize
    rho = repmat(0,size(x));
    u   = repmat(0,size(x));
    p   = repmat(0,size(x));
    T   = repmat(0,size(x));
    M   = repmat(0,size(x));
    c   = repmat(0,size(x));

    % upstream conditions
    pt1 = 101325; %Pa
    Tt1 = 300;    %K

    % Find Mach number in nozzle
    if (xs < 0) 
        % If inlet flow is subsonic (shock in front of nozzle)
        iu = 1:Nx;
        id = [];
        %M_guess = 0.5;  % Guess of Mach number upstream
    else
        % If inlet flow is supersonic
        iu = find(x < xs);
        id = find(x >= xs);
        %M_guess = 1.5;  % Guess of Mach number upstream   
    end
    
    % Compute upstream supersonic flow Mach number at x locations
    M(iu) = AreaMachRelation(x(iu),g,Astar,M_guess);
    
    % Find shock conditions
    if (xs > 0)
        M1   = AreaMachRelation(xs,g,Astar,M_guess_shock);
        p1   = pt1 ./ (1 + (g-1)/2*M1^2)^(g/(g-1));
        T1   = Tt1 ./ (1 + (g-1)/2*M1^2);
        rho1 = p1 / (R * T1);
    end 

    % Compute static values upstream of shock
    p(iu) = pt1 ./ (1 + (g-1)/2.*M(iu).^2) .^ (g/(g-1));
    T(iu) = Tt1 ./ (1 + (g-1)/2.*M(iu).^2);
    rho(iu) = p(iu) ./ (R * T(iu));
    c(iu) = sqrt(g * R * T(iu));
    u(iu) = M(iu) .* c(iu);

    if (xs > 0)
        % Find post-shock conditions
        M2   = sqrt((M1^2+2/(g-1))/(2*g/(g-1)*M1^2-1));
        rho2 = (g+1)*M1^2/(2 + (g-1)*M1^2) * rho1;
        p2   = (1 + (2*g)/(g+1)*(M1^2-1))*p1;
        T2   = p2 / (R * rho2);
        pt2  = p2 * (1 + (g-1)/2*M2^2)^(g/(g-1));
        Tt2  = Tt1;
        Astar2 = Astar*(pt1/pt2);

        % Compute downstream Mach number
        M(id) = AreaMachRelation(x(id),g,Astar2,0.5);

        % compute downstream quantitites
        p(id) = pt2 ./ (1 + (g-1)/2*M(id).^2).^(g/(g-1));
        T(id) = Tt2 ./ (1 + (g-1)/2*M(id).^2);
        rho(id) = p(id) ./ (R * T(id));
        c(id) = sqrt(g * R * T(id));
        u(id) = M(id) .* c(id);
    end
end

% function [A,dA] = Area(x)
%     % Input is the x location on the nozzle
%     % OUTPUT: Area and the Change in Area
%     A0 = 0.2;
%     rc = 0.5;
%     x0 = 0.5;
%     tanTheta = 0.25;
% 
%     % Linear part of the nozzle
%     S1 =  tanTheta*x;
%     S2 = (tanTheta*x0)-tanTheta*(x-x0);
%     xpatch = 0.378732187461209; 
% 
%     b = tanTheta*xpatch - sqrt(rc^2 - (xpatch-x0)^2);
% 
%     inlet = find(x<xpatch);
%     delta = x0 - xpatch;
%     outlet = find(x>x0+delta);
%     A = sqrt(rc^2 - (x-x0).^2)+b;
%     A(inlet) = S1(1:max(inlet));
%     A(outlet)= S2(min(outlet):length(x));
%     A = A0-A;
% 
%     dA         = (-x0 + x)./sqrt((1.0 - x).*x);
%     dA(inlet)  = -tanTheta;
%     dA(outlet) =  tanTheta;
% end
function [A,dA] = Area(x)

  a = 1.8;
  s = 5;

  A  = 1.398 + 0.347 * tanh(a*(x-s));
  dA = 0.347 * a * sech(a*(x-s)) .* sech(a*(x-s)); 
  
end

function M = AreaMachRelation(x,g,Astar, guess)

  % compute area
  A = Area(x);
  
  % output vector
  M = zeros(size(x));
  
  for i = 1:length(x)
      M(i) = fzero(@(y) (A(i)/Astar)^2 - (1./y).^2.*(2/(g+1)*(1+(g-1)/2.*y.^2)).^((g+1)/(g-1)), guess);
  end
  
  return
end


%% Compute the right hand side of the flux for quasi-1d flow
function qdot = FluxRHS1D(t, q, x, L, Nx, gamma)
    % Define matrices
    qdot1 = zeros(Nx ,1);
    qdot2 = zeros(Nx ,1);
    qdot3 = zeros(Nx ,1);
    F = zeros(Nx+1 ,3);

    q1 = q(       1:Nx,   1);
    q2 = q(Nx   + 1:2*Nx, 1);
    q3 = q(2*Nx + 1:3*Nx, 1);

    % Compute fluxes for interior domain
    for i=2:Nx
        ql = [q1(i-1); q2(i-1); q3(i-1)];
        qr = [q1(i); q2(i); q3(i)];
        [F(i ,:)] = RoeSolver(ql, qr, gamma);
    end
    
    % Compute fluxes at boundaries
    ql1 = [q1(1); q2(1); q3(1)];
    qr1 = [q1(1); q2(1); q3(1)];
    ql2 = [q1(Nx); q2(Nx); q3(Nx)];
    qr2 = [q1(Nx); q2(Nx); q3(Nx)];
    [F(1,:)] = RoeSolver(ql1, qr1, gamma);
    [F(Nx+1 ,:)]= RoeSolver(ql2, qr2, gamma);
    
    dx = L/Nx;
    % Compute the RHS
    qdot1(:,1) = -1/dx *(F(2:end ,1) - F(1:end-1 ,1));
    ddot2(:,1) = -1/dx *(F(2:end ,2) - F(1:end-1 ,2));
    ddot3(:,1) = -1/dx *(F(2:end ,3) - F(1:end-1 ,3));

    % stack to obtain column vector
    qdot = [qdot1 ; ddot2; ddot3];
end

function [Fip] = RoeSolver(ql, qr, gamma)
    % Calculates the fluxes at cell boundaries
    % INPUT: 
    %   ql: left side states
    %   qr: right side states
    %   gamma: gamma for fluid
    % OUTPUT:
    %   Fip: numerical flux of cell 

    % Calculate primitive variables
    ul = ql(2)/ ql(1);
    ur = qr(2)/ qr(1);
    rhol = ql (1);
    rhor = qr (1);
    pl = (gamma - 1)*( ql (3) -0.5* rhol *ul ^2 );
    pr = (gamma - 1)*( qr (3) -0.5* rhor *ur ^2 );

    % Compute speed of sound
    al = sqrt(gamma * pl / rhol );
    ar = sqrt(gamma * pr / rhor );
    
    % Compute total specific enthalpy
    Hl = al ^2 / (gamma - 1.0) + 0.5 * ul ^2;
    Hr = ar ^2 / (gamma - 1.0) + 0.5 * ur ^2;

    % Compute Roe averages
    rt = sqrt ( rhor / rhol );
    rm = sqrt ( rhol * rhor );
    um = (ul + rt * ur) / (1.0 + rt );
    Hm = (Hl + rt * Hr) / (1.0 + rt );
    am = sqrt((gamma - 1.0) * (Hm - 0.5 * um ^2));

    % Compute derivatives
    dr = rhor - rhol;
    du = ur - ul;
    dp = pr - pl;

    % Compute wave strength
    alpha = [(dp - am * rm * du) / (2.0 * am ^2);...
              dr - dp / am ^2;...
             (dp + am * rm * du) / (2.0 * am ^2)];

    % Compute the eigenvalues
    wm = [um - am; um; um + am];

    % Compute the eigenvectors
    v1 = [1.0,          1.0,            1.0];
    v2 = [um - am,      um,             um + am ];
    v3 = [Hm - um * am, 0.5 * um ^2,    Hm + um * am ];
    V = [v1; v2; v3];
    
    % Compute the fluxes
    fl = [ql(2); ql(2)* ul+pl; ul *(ql(3)+ pl)];
    fr = [qr(2); qr(2)* ur+pr; ur *(qr(3)+ pr)];
    
    % Compute the average flux for the cell
    Fip = 0.5 * (fr + fl) - 0.5 * V*(abs(wm ).* alpha);
end

function [out] = guessp(WL, WR, G)
%GUESSP: provide a guess value for pressure PM in Star Region

  % expand input
  rhoL = WL(1); uL = WL(2); pL = WL(3); cL = WL(4);
  rhoR = WR(1); uR = WR(2); pR = WR(3); cR = WR(4);
  G1 = G(1); G3 = G(3); G4 = G(4); G5 = G(5); G6 = G(6); G7 = G(7);

  quser = 2;
  cup   = 0.25*(rhoL + rhoR)*(cL + cR);
  ppv   = max(0.5*(pL + pR) + 0.5*(uL - uR)*cup,0);
  pmin  = min(pL,pR);
  pmax  = max(pL,pR);
  qmax  = pmax/pmin;
  
  if (qmax <= quser & (pmin <= ppv & ppv <= pmax))
      pm = ppv;
  else
      if (ppv < pmin)
          pq = (pL/pR)^G1;
          um = (pq*uL/cL + uR/cR + G4*(pq-1))/(pq/cL+1/cR);
          ptL = 1.0 + G7*(uL-um)/cL;
          ptR = 1.0 + G7*(um-uR)/cR;
          pm  = 0.5*(pL*ptL^G3 + pR*ptR^G3);
      else
          gel = sqrt((G5/rhoL)/(G6*pL+ppv));
          ger = sqrt((G5/rhoR)/(G6*pR+ppv));
          pm  = (gel*pL + ger*pR - (uR-uL))/(gel+ger);
      end
  end
          
  out = pm;
    
end

function [f, fd] = prefun(p, dk, pk, ck, G)
%PREFUN: evaluate the pressure functions fL and fR in exact Riemann solver

  % expand input
  G1 = G(1); G2 = G(2); G4 = G(4); G5 = G(5); G6 = G(6);

  if (p <= pk)
      prat = p/pk;
      f    = G4*ck*(prat^G1-1);
      fd   = (1/(dk*ck))*prat^(-G2);
  else
      ak   = G5/dk;
      bk   = G6*pk;
      qrt  = sqrt(ak/(bk+p));
      f    = (p-pk)*qrt;
      fd   = (1.0 - 0.5*(p-pk)/(bk+p))*qrt;
  end

end

function [p, u] = starpu( WL, WR, G)
%STARPU: compute the solution for pressure and velocity in the Star Region

  % expand input
  rhoL = WL(1); uL = WL(2); pL = WL(3); cL = WL(4);
  rhoR = WR(1); uR = WR(2); pR = WR(3); cR = WR(4);
  G1 = G(1); G3 = G(3); G4 = G(4); G5 = G(5); G6 = G(6); G7 = G(7);

  % initialize newton-rhapson
  pstart = guessp(WL,WR,G);
  pold   = pstart;
  udiff  = uR - uL;
  tolpre = 1e-6;
  nriter = 20;
  count  = 1;
  change  = 1;
  
  % compute pressure
  while (change > tolpre)
      [fL, fLD] = prefun(pold, rhoL, pL, cL, G);
      [fR, fRD] = prefun(pold, rhoR, pR, cR, G);
      p = pold - (fL + fR + udiff)/(fLD+fRD);
      change = 2*abs((p-pold)/(p+pold));
      if (p < 0)
          p = tolpre;
      end
      pold = p;
  end
  
  % compute velocity
  u = 0.5*(uL + uR + fR - fL);
  
end