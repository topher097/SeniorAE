%% AE410 Final Project
% Author:   Christopher Endres
% Date:     5/6/2020
clc;
clear all;
close all;

%% Problem 1
% Calculate the flow within a supersonic inlet (area of the nozzle is
% defined in Area.m)
% Use equally spaced volumes located along y=0 to span the volume

%% Case 1 - Mach = 0, no flow
clc;
clear all;
% Default values, don't modify
L       = 1;        % x in [0,1]
Nx      = 41;      % Number of nodes
Nv      = Nx-1;     % Number of volumes 
gamma   = 1.4;      
R       = 287.04;
A_in    = Area(0);  % Area at inlet
A_out   = Area(L);  % Area at outlet
x       = linspace(0, L, Nx);

% Case-dependant values
A = Area(x);
M = 0;
Astar = A/(((gamma+1)/2)^((-gamma+1)/(2*(gamma-1))) * ((1+(gamma-1)*M^2)^((gamma+1)/(2*(gamma-1))))/M);

% Compute the exact solution for case
Ae = A;
ue = zeros(Nx, 1);
Me = M*ones(Nx, 1);
pt = ones(Nx, 1) .* 10e6;    
pe = pt .* (1+(gamma-1)/2 * M^2)^(-gamma/(gamma-1));
Tt = 300;       % static temperature (K)
rhoe = pe ./ (R * Tt);
xe = x';

Tt  = pe ./ (R * rhoe);
pte = pe .* (1 + (gamma-1)/2*Me.^2).^(gamma/(gamma-1));
Tte = Tt .* (1 + (gamma-1)/2*Me.^2);
dse = - R * log(pte./pte(1));

% Compute the Finite Volume solution
q0    = [rhoe; rhoe .* ue; pe/(gamma-1) + 0.5 * rhoe .* ue .* ue];
t0    = [0 0.005];
dpdt  = 0;
[t,q] = ode45(@(t,y) FluxRHS1D(t,y,x,L,Nx,gamma,dpdt), t0, q0);

% Extract 'final' solutions
rho  = q(end,1:Nx);
u    = q(end,Nx+1:2*Nx) ./ rho;
p    = (gamma-1)*(q(end,2*Nx+1:3*Nx) - 0.5 * rho .* u .* u);
M    = u ./ sqrt(gamma * p ./ rho);
T    = p ./ (R * rho);
pt   = p .* (1 + (gamma-1)/2*M.^2).^(gamma/(gamma-1));
Tt   = T .* (1 + (gamma-1)/2*M.^2);
ds   = - R * log(pt./pt(1));

case_num = 1;
% a) Plot exact/initial over x for case 1-3
figure(4*case_num+0), clf;
set(gcf,'Position',[0 50 800 800])
p_0 = pe(1); rho0 = rhoe(1); u0 = ue(1);
p_text = sprintf('p/p_o', 'interpreter', 'latex');
rho_text = sprintf('\\rho/\\rho_o', 'interpreter', 'latex');
u_text = sprintf('u/u_o', 'interpreter', 'latex');
f = 16; lw = 1.5;
subplot(3,1,1); plot(xe,pe./p_0, 'linewidth', lw); xlabel('x [m]', 'fontsize', f); ylabel([p_text], 'fontsize', f);
subplot(3,1,2); plot(xe,rhoe./rho0, 'linewidth', lw); xlabel('x [m]', 'fontsize', f); ylabel([rho_text], 'fontsize', f);
subplot(3,1,3); plot(xe,ue./u0, 'linewidth', lw); ylim([-0.5 0.5]); xlabel('x [m]', 'fontsize', f); ylabel([u_text], 'fontsize', f);
saveas(gcf, sprintf('plots\\case%0.15g_plot_a.png', case_num));

% b) Plot numerical solution (ode45 solution) over x for case 1 and 2
figure(4*case_num+1), clf;
set(gcf,'Position',[800 50 800 250])
p0 = p(1);
p_text = sprintf('p/p_o', 'interpreter', 'latex');
f = 16; lw = 1.5;
plot(x,p./p0, 'linewidth', lw); xlabel('x [m]', 'fontsize', f); ylabel([p_text], 'fontsize', f); 
saveas(gcf, sprintf('plots\\case%0.15g_plot_b.png', case_num));

%% Case 2 - Mach 2.5, no shockwave
clc;
clear all;
% Default values, don't modify
L       = 1;        % x in [0,1]
Nx      = 41;      % Number of nodes
Nv      = Nx-1;     % Number of volumes 
gamma   = 1.4;      
R       = 287.04;
A_in    = Area(0);  % Area at inlet
A_out   = Area(L);  % Area at outlet
x       = linspace(0, L, Nx);

% Case-dependant values
Minlet          = 2.5;      % Mach number at the inlet
M_guess_shock   = 2.5;      % Mach number at shock
M_guess         = 2.5;        % Guess of Mach number upstream 
[A, dA]         = Area(x);
A_Astar         = sqrt((1/Minlet)^2*(2/(gamma+1)*(1+(gamma-1)/2*Minlet^2))^((gamma+1)/(gamma-1)));
Astar           = 1/A_Astar*A(1); 
xs              = -1;       % X-location of shock (not in nozzle)

% Compute the exact solution for case
[xe,Ae,dAe,rhoe,ue,pe,Me] = ExactSolution(gamma,R,xs,Astar,L,Nx,M_guess_shock,M_guess);
Te     = pe ./ (R * rhoe);
pte    = pe .* (1 + (gamma-1)/2*Me.^2).^(gamma/(gamma-1));
Tte    = Te .* (1 + (gamma-1)/2*Me.^2);
dse    = - R * log(pte./pte(1));
Ashock = interp1(xe,Ae,xs);

% Compute the Finite Volume solution
q0    = [rhoe; rhoe .* ue; pe/(gamma-1) + 0.5 * rhoe .* ue .* ue];
t0    = [0 0.005];
dpdt  = 0;
[t,q] = ode45(@(t,y) FluxRHS1D(t,y,x,L,Nx,gamma,dpdt), t0, q0);

% Extract 'final' solutions
rho  = q(end,1:Nx);
u    = q(end,Nx+1:2*Nx) ./ rho;
p    = (gamma-1)*(q(end,2*Nx+1:3*Nx) - 0.5 * rho .* u .* u);
M    = u ./ sqrt(gamma * p ./ rho);
T    = p ./ (R * rho);
pt   = p .* (1 + (gamma-1)/2*M.^2).^(gamma/(gamma-1));
Tt   = T .* (1 + (gamma-1)/2*M.^2);
ds   = - R * log(pt./pt(1));

case_num = 2;
% a) Plot exact/initial over x for case 1-3
figure(4*case_num+0), clf;
set(gcf,'Position',[0 50 800 800])
p_0 = pe(1); rho0 = rhoe(1); u0 = ue(1);
p_text = sprintf('p/p_o', 'interpreter', 'latex');
rho_text = sprintf('\\rho/\\rho_o', 'interpreter', 'latex');
u_text = sprintf('u/u_o', 'interpreter', 'latex');
f = 16; lw = 1.5;
subplot(3,1,1); plot(xe,pe./p_0, 'linewidth', lw); xlabel('x [m]', 'fontsize', f); ylabel([p_text], 'fontsize', f);
subplot(3,1,2); plot(xe,rhoe./rho0, 'linewidth', lw); xlabel('x [m]', 'fontsize', f); ylabel([rho_text], 'fontsize', f);
subplot(3,1,3); plot(xe,ue./u0, 'linewidth', lw); xlabel('x [m]', 'fontsize', f); ylabel([u_text], 'fontsize', f);
saveas(gcf, sprintf('plots\\case%0.15g_plot_a.png', case_num));

% b) Plot numerical solution (ode45 solution) over x for case 1 and 2
figure(4*case_num+1), clf;
set(gcf,'Position',[800 50 800 250])
p0 = p(1);
p_text = sprintf('p/p_o', 'interpreter', 'latex');
f = 16; lw = 1.5;
plot(x,p./p0, 'linewidth', lw); xlabel('x [m]', 'fontsize', f); ylabel([p_text], 'fontsize', f); 
saveas(gcf, sprintf('plots\\case%0.15g_plot_b.png', case_num));


%% Case 3 - Mach 2.5, shock at x=0.85
clc;
clear all;
% Default values, don't modify
L       = 1;        % x in [0,1]
Nx      = 41;       % Number of nodes
Nv      = Nx-1;     % Number of volumes 
gamma   = 1.4;      
R       = 287.04;
A_in    = Area(0);  % Area at inlet
A_out   = Area(L);  % Area at outlet
x       = linspace(0, L, Nx);

% Case-dependant values
Minlet          = 2.5;      % Mach number at the inlet
M_guess_shock   = 2.5;      % Mach number at shock
M_guess         = 2.5;      % Guess of Mach number upstream 
[A, dA]         = Area(x);
A_Astar         = sqrt((1/Minlet)^2*(2/(gamma+1)*(1+(gamma-1)/2*Minlet^2))^((gamma+1)/(gamma-1)));
Astar           = 1/A_Astar*A(1); 
xs              = 0.85;       % X-location of shock

% Compute the exact solution for case
[xe,Ae,dAe,rhoe,ue,pe,Me] = ExactSolution(gamma,R,xs,Astar,L,Nx,M_guess_shock,M_guess);
Te     = pe ./ (R * rhoe);
pte    = pe .* (1 + (gamma-1)/2*Me.^2).^(gamma/(gamma-1));
Tte    = Te .* (1 + (gamma-1)/2*Me.^2);
dse    = - R * log(pte./pte(1));
Ashock = interp1(xe,Ae,xs);

% Compute the Finite Volume solution
q0    = [rhoe; rhoe .* ue; pe/(gamma-1) + 0.5 * rhoe .* ue .* ue];
t0    = [0 0.005];
dpdt  = 0;
[t,q] = ode45(@(t,y) FluxRHS1D(t,y,x,L,Nx,gamma,dpdt), t0, q0);

% Extract 'initial' solutions
rho0  = q(1,1:Nx);
u0    = q(1,Nx+1:2*Nx) ./ rho0;
p0    = (gamma-1)*(q(1,2*Nx+1:3*Nx) - 0.5 * rho0 .* u0 .* u0);
M0    = u0 ./ sqrt(gamma * p0 ./ rho0);
T0    = p0 ./ (R * rho0);

% Extract 'intermediate' solutions
index = round(length(t)/2, 0);
rho1  = q(index,1:Nx);
u1    = q(index,Nx+1:2*Nx) ./ rho1;
p1    = (gamma-1)*(q(index,2*Nx+1:3*Nx) - 0.5 * rho1 .* u1 .* u1);
M1    = u1 ./ sqrt(gamma * p1 ./ rho1);
T1    = p1 ./ (R * rho1);

% Extract 'final' solutions
rho2  = q(end,1:Nx);
u2    = q(end,Nx+1:2*Nx) ./ rho2;
p2    = (gamma-1)*(q(end,2*Nx+1:3*Nx) - 0.5 * rho2 .* u2 .* u2);
M2    = u2 ./ sqrt(gamma * p2 ./ rho2);
T2    = p2 ./ (R * rho2);

case_num = 3;
% a) Plot exact/initial over x for case 1-3
figure(4*case_num+0), clf;
set(gcf,'Position',[0 50 800 800])
po = pe(1); rho0 = rhoe(1); u0 = ue(1);
p_text = sprintf('p/p_o', 'interpreter', 'latex');
rho_text = sprintf('\\rho/\\rho_o', 'interpreter', 'latex');
u_text = sprintf('u/u_o', 'interpreter', 'latex');
f = 16; lw = 1.5;
subplot(3,1,1); plot(xe,pe./po, 'linewidth', lw); xlabel('x [m]', 'fontsize', f); ylabel(p_text, 'fontsize', f);
subplot(3,1,2); plot(xe,rhoe./rho0, 'linewidth', lw); xlabel('x [m]', 'fontsize', f); ylabel(rho_text, 'fontsize', f);
subplot(3,1,3); plot(xe,ue./u0, 'linewidth', lw); xlabel('x [m]', 'fontsize', f); ylabel(u_text, 'fontsize', f);
saveas(gcf, sprintf('plots\\case%0.15g_plot_a.png', case_num));

% c) Plot numerical solution (ode45 solution) over x for 3 different time
% steps
figure(4*case_num+1), clf;
set(gcf,'Position',[800 50 1000 400])
p00 = p0(1); p01 = p1(1); p02 = p2(1);
p_text = sprintf('p/p_o', 'interpreter', 'latex');
f = 16; lw = 1.5;
t0 = t(1); t1 = t(index); t2 = t(end);
hold on
plot(x,p0./p00, 'linewidth', lw); xlabel('x [m]', 'fontsize', f); ylabel(p_text, 'fontsize', f);
plot(x,p1./p01, 'linewidth', lw); xlabel('x [m]', 'fontsize', f); ylabel(p_text, 'fontsize', f); 
plot(x,p2./p02, 'linewidth', lw); xlabel('x [m]', 'fontsize', f); ylabel(p_text, 'fontsize', f); 
legend({sprintf('Time = %0.15g s', t0),sprintf('Time = %0.15g s', round(t1,5)),sprintf('Time = %0.15g s', round(t2,5))},'location','eastoutside')
saveas(gcf, sprintf('plots\\case%0.15g_plot_c_pressure.png', case_num));

figure(4*case_num+2), clf;
set(gcf,'Position',[800 450 1000 400])
f = 16; lw = 1.5;
t0 = t(1); t1 = t(index); t2 = t(end);
hold on
plot(x,M0, 'linewidth', lw); xlabel('x [m]', 'fontsize', f); ylabel('M', 'fontsize', f);
plot(x,M1, 'linewidth', lw); xlabel('x [m]', 'fontsize', f); ylabel('M', 'fontsize', f); 
plot(x,M2, 'linewidth', lw); xlabel('x [m]', 'fontsize', f); ylabel('M', 'fontsize', f); 
legend({sprintf('Time = %0.15g s', t0),sprintf('Time = %0.15g s', round(t1,5)),sprintf('Time = %0.15g s', round(t2,5))},'location','eastoutside')
saveas(gcf, sprintf('plots\\case%0.15g_plot_c_mach.png', case_num));


%% Case 4 - Mach 2.5, shock at x=0.85, const outlet pressure, then increase outlet pressure by 67%
clc;
clear all;
% Default values, don't modify
L       = 1;        % x in [0,1]
Nx      = 41;       % Number of nodes
Nv      = Nx-1;     % Number of volumes 
gamma   = 1.4;      
R       = 287.04;
A_in    = Area(0);  % Area at inlet
A_out   = Area(L);  % Area at outlet
x       = linspace(0, L, Nx);

% Case-dependant values
Minlet          = 2.5;      % Mach number at the inlet
M_guess_shock   = 2.5;      % Mach number at shock
M_guess         = 2.5;        % Guess of Mach number upstream 
[A, dA]         = Area(x);
A_Astar         = sqrt((1/Minlet)^2*(2/(gamma+1)*(1+(gamma-1)/2*Minlet^2))^((gamma+1)/(gamma-1)));
Astar           = 1/A_Astar*A(1); 
xs              = 0.85;       % X-location of shock (not in nozzle)

% Compute the exact solution for case
[xe,Ae,dAe,rhoe,ue,pe,Me] = ExactSolution(gamma,R,xs,Astar,L,Nx,M_guess_shock,M_guess);
Te     = pe ./ (R * rhoe);
pte    = pe .* (1 + (gamma-1)/2*Me.^2).^(gamma/(gamma-1));
Tte    = Te .* (1 + (gamma-1)/2*Me.^2);
dse    = - R * log(pte./pte(1));
Ashock = interp1(xe,Ae,xs);

% Create dpdt value given requirements in document
t_0    = 0.001;        % seconds
dpdt_0 = 0;
t_1    = 0.0011;        % seconds
dpdt_1 = 0.67/0.0001;
dpdt_1 = 0;
dpdt_2 = 0;

% Compute the Finite Volume solution
% from 0 to t_0, mult pe by dpdt_0, from t_0 to t_1, mult p_e by dpdt_1, from t_1 to end mult pe by dpdt_2
q0    = [rhoe; rhoe .* ue; pe/(gamma-1) + 0.5 * rhoe .* ue .* ue];
t0    = [0 t_0];
dpdt  = dpdt_0;
[t_00,q_0] = ode45(@(t,y) FluxRHS1D(t,y,x,L,Nx,gamma,dpdt), t0, q0);


q0    = q_0(end,1:end);
t0    = [t_0 t_1];
dpdt  = dpdt_1;
[t_11,q_1] = ode45(@(t,y) FluxRHS1D(t,y,x,L,Nx,gamma,dpdt), t0, q0);
rho  = q_1(end,1:Nx);
u    = q_1(end,Nx+1:2*Nx) ./ rho;
p    = (gamma-1)*(q_1(end,2*Nx+1:3*Nx) - 0.5 * rho .* u .* u);

q0    = q_1(end,1:end);
t0    = [t_1 0.005];
dpdt  = dpdt_2;
[t_22,q_2] = ode45(@(t,y) FluxRHS1D(t,y,x,L,Nx,gamma,dpdt), t0, q0);
q = [q_0; q_1; q_2];
t = [t_00; t_11; t_22];

% Extract 'final' solutions
rho  = q(end,1:Nx);
u    = q(end,Nx+1:2*Nx) ./ rho;
p    = (gamma-1)*(q(end,2*Nx+1:3*Nx) - 0.5 * rho .* u .* u);
M    = u ./ sqrt(gamma * p ./ rho);
T    = p ./ (R * rho);
pt   = p .* (1 + (gamma-1)/2*M.^2).^(gamma/(gamma-1));
Tt   = T .* (1 + (gamma-1)/2*M.^2);
ds   = - R * log(pt./pt(1));

case_num = 4;
% d) Plot numerical solution (ode45 solution) over x for case 1 and 2
figure(4*case_num+0), clf;
set(gcf,'Position',[0 50 800 400])
p0 = p(1);
p_text = sprintf('p/p_o', 'interpreter', 'latex');
f = 16; lw = 1.5;
plot(xe,p./p0, 'linewidth', lw); xlabel('x [m]', 'fontsize', f); ylabel(p_text, 'fontsize', f);
saveas(gcf, sprintf('plots\\case%0.15g_plot_d.png', case_num));



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
    pt1 = 10e6; %Pa
    Tt1 = 300;    %K

    % Find Mach number in nozzle
    if (xs < 0) 
        % If inlet flow is subsonic (shock in front of nozzle)
        iu = 1:Nx;
        id = [];
        M_guess = 0.5;  % Guess of Mach number upstream
    else
        % If inlet flow is supersonic
        iu = find(x < xs);
        id = find(x >= xs);
        M_guess = 1.5;  % Guess of Mach number upstream   
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

function [A,dA] = Area(x)
    % Input is the x location on the nozzle
    % OUTPUT: Area and the Change in Area
    A0 = 0.2;
    rc = 0.5;
    x0 = 0.5;
    tanTheta = 0.25;

    % Linear part of the nozzle
    S1 =  tanTheta*x;
    S2 = (tanTheta*x0)-tanTheta*(x-x0);
    xpatch = 0.378732187461209; 

    b = tanTheta*xpatch - sqrt(rc^2 - (xpatch-x0)^2);

    inlet = find(x<xpatch);
    delta = x0 - xpatch;
    outlet = find(x>x0+delta);
    A = sqrt(rc^2 - (x-x0).^2)+b;
    A(inlet) = S1(1:max(inlet));
    A(outlet)= S2(min(outlet):length(x));
    A = A0-A;

    dA         = (-x0 + x)./sqrt((1.0 - x).*x);
    dA(inlet)  = -tanTheta;
    dA(outlet) =  tanTheta;
end

function M = AreaMachRelation(x,g,Astar,guess)

  % compute area
  A = Area(x);
  
  % output vector
  M = zeros(size(x));
  
  for i = 1:length(x)
      M(i) = fzero(@(y) (A(i)/Astar)^2 - (1./y).^2.*(2/(g+1)*(1+(g-1)/2.*y.^2)).^((g+1)/(g-1)),guess);
  end
  
  return
end

%% Compute the right hand side of the flux for quasi-1d flow
function qdot = FluxRHS1D(t, q, x, L, Nx, gamma, dpdt)
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
        [F(i ,:)] = RoeSolver(ql, qr, gamma, 0);
    end
    
    % Compute fluxes at boundaries
    ql1 = [q1(1); q2(1); q3(1)];
    qr1 = [q1(1); q2(1); q3(1)];
    ql2 = [q1(Nx); q2(Nx); q3(Nx)];
    qr2 = [q1(Nx); q2(Nx); q3(Nx)];
    [F(1,:)] = RoeSolver(ql1, qr1, gamma, 0);
    [F(Nx+1 ,:)]= RoeSolver(ql2, qr2, gamma, dpdt);
    
    dx = L/Nx;
    % Compute the RHS
    qdot1(:,1) = -1/dx *(F(2:end ,1) - F(1:end-1 ,1));
    ddot2(:,1) = -1/dx *(F(2:end ,2) - F(1:end-1 ,2));
    ddot3(:,1) = -1/dx *(F(2:end ,3) - F(1:end-1 ,3));

    % stack to obtain column vector
    qdot = [qdot1 ; ddot2; ddot3];
end

function [Fip] = RoeSolver(ql, qr, gamma, dpdt)
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
    pl = (gamma - 1)*(ql(3) -0.5* rhol *ul^2);
    pr = (gamma - 1)*(qr(3) -0.5* rhor *ur^2);

    % Compute speed of sound
    al = sqrt(gamma * pl / rhol);
    ar = sqrt(gamma * pr / rhor);
    
    % Compute total specific enthalpy
    Hl = al^2 / (gamma - 1.0) + 0.5 * ul^2;
    Hr = ar^2 / (gamma - 1.0) + 0.5 * ur^2;

    % Compute Roe averages
    rt = sqrt(rhor / rhol);
    rm = sqrt(rhol * rhor);
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
