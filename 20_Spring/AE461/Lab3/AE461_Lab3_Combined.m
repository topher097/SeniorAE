%% AE461 Lab 3 
clc;
clear all;
close all;

%% Load and Define Data
load('GroupP_lab3.mat')
% Physical properties of bars
length      = 25.875;   % inches
diam        = 1.5;      % inches
al_thick    = 0.125;    % inches
al_E        = 10e6;     % PSI
al_poisson  = 0.34;
cp_thick    = 0.075;    % inches
cp_E        = 1.92e6;   % PSI
cp_poisson  = 0.51;

% Strain gauge and force distances from y = 0 (origin of system)
dist_force      = -3.75;        % inches
dist_sg1        = 20.375;       % inches
dist_sg2        = 8;            % inches
theta           = deg2rad(45);  % readians of strain gauge angle

% Re-write the loaded data to easier to type variables
dg_al_bend      = dialgauge_al_bending/1000;                    % inches
dg_al_bendtor   = dialgauge_al_bendingtorsion/1000;             % inches
dg_cp_bend      = dialgauge_composite_bending/1000;             % inches
dg_cp_bendtor   = dialgauge_composite_bendingtorsion/1000;      % inches
sg_al_bend      = (straingauge_al_bending - straingauge_al_bending(1,:))/1000000;                               % inches
sg_al_bendtor   = (straingauge_al_bendingtorsion - straingauge_al_bendingtorsion(1,:))/1000000;                 % inches
sg_cp_bend      = (straingauge_composite_bending - straingauge_composite_bending(1,:))/1000000;                 % inches
sg_cp_bendtor   = (straingauge_composite_bendingtorsion - straingauge_composite_bendingtorsion(1,:))/1000000;   % inches

%% Calculations for Aluminum 
% Define empty arrays
astrain_x = [];
astrain_y = [];
agamma_xy = [];
astress_y = [];
astress_ys = [];
agamma_ys = [];
aM_x      = [];
aM_y      = [];
avg_astrain_x = [];
avg_astrain_y = [];
avg_agamma_xy = [];
avg_astress_y = [];
avg_astress_ys = [];
avg_agamma_ys = [];
avg_aM_x      = [];
avg_aM_y      = [];
avg_aalpha    = [];

% Iterate through each load to do calculations
for i = 1:size(loadP)
    load = loadP(i);
    poisson = 0.3039;       % calculated poisson
    youngs = 5.4318e+06;    % calculated young's modulus
    G = youngs/(2*(1+poisson));
    thick = al_thick;
    ri = diam/2 - thick;
    ro = diam/2;
    
    % Calculate the strain in x and y
    sg1 = sg_al_bendtor(i, 1:3);
    sg2 = sg_al_bendtor(i, 4:6);
    gamma_xy1 = sg1(1) - sg1(3);
    gamma_xy2 = sg2(1) - sg2(3);
    strain_x1 = sg1(1) + sg1(3) - sg1(2);
    strain_x2 = sg2(1) + sg2(3) - sg2(2);
    strain_y1 = sg1(2);
    strain_y2 = sg2(2);
    avg_gamma_xy = mean([gamma_xy1, gamma_xy2]);
    avg_strain_x = mean([strain_x1, strain_x2]);
    avg_strain_y = mean([strain_y1, strain_y2]);
    
    % Calculate magnitude of moment at each rosette and I_xx
    M_x1 = load * (dist_sg1 - dist_force);
    M_x2 = load * (dist_sg2 - dist_force);
    I_xx = pi/4 * (ro^4 - ri^4);
    avg_M_x = mean([M_x1 M_x2]);
    
    % Solve for bending stress at each rosette
    stress_y1 = M_x1/I_xx * ro;
    stress_y2 = M_x2/I_xx * ro; 
    avg_stress_y = mean([stress_y1 stress_y2]);
    
    % Compute twisting moment given the combined load
    % Note sigma_sy = sigma_xy and gamma_sy = gamma_xy
    stress_ys1 = G * gamma_xy1;
    stress_ys2 = G * gamma_xy2;
    gamma_ys1 = gamma_xy1;
    gamma_ys2 = gamma_xy2;
    M_y1 = stress_ys1*2*thick*pi/4*(ri+ro)^2;
    M_y2 = stress_ys2*2*thick*pi/4*(ri+ro)^2;
    avg_stress_ys = mean([stress_ys1 stress_ys2]);
    avg_gamma_ys = mean([gamma_ys1 gamma_ys2]);
    avg_M_y = mean([M_y1 M_y2]);
    
    % Copmute alpha of beam under combined load
    J = pi/2 * (ro^4 - ri^4);
    alpha1 = M_y1/(G*J);
    alpha2 = M_y2/(G*J);
    avg_alpha = mean([alpha1 alpha2]);
    
    
    % Store all data to arrays
    astrain_x = [astrain_x; strain_x1, strain_x2];
    astrain_y = [astrain_y; strain_y1, strain_y2];
    astress_y = [astress_y; stress_y1, stress_y2];
    agamma_xy = [agamma_xy; gamma_xy1, gamma_xy2];
    astress_ys = [astress_ys; stress_ys1, stress_ys2];
    agamma_ys = [agamma_ys; gamma_ys2, gamma_ys2];
    aM_x      = [aM_x; M_x1, M_x2];
    aM_y      = [aM_y; M_y1, M_y2];
    avg_astrain_x = [avg_astrain_x; avg_strain_x];
    avg_astrain_y = [avg_astrain_y; avg_strain_y];
    avg_astress_y = [avg_astress_y; avg_stress_y];
    avg_agamma_xy = [avg_agamma_xy; avg_gamma_xy];
    avg_astress_ys = [avg_astress_ys; avg_stress_ys];
    avg_agamma_ys = [avg_agamma_ys; avg_gamma_ys];    
    avg_aM_x      = [avg_aM_x; avg_M_x];
    avg_aM_y      = [avg_aM_y; avg_M_y];
    avg_aalpha     = [avg_aalpha; avg_alpha];
end

% Calc angle of end of beam
alpha_al = rad2deg(avg_aalpha);                % degrees/inch
theta_beam_al = length * alpha_al;                     % degrees
J_al = J;

%% Plots for Aluminum
% Plot strain curve
poisson = -avg_astrain_x/avg_astrain_y;
poisson_al = mean(poisson(:,5));
figure(1)
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
hold on
plot(astrain_y(:,1), astrain_x(:,1))
plot(astrain_y(:,2), astrain_x(:,2))
plot(avg_astrain_y, avg_astrain_x)
grid on
hold off
legend('Strain Gauge 1', 'Strain Gauge 2', 'Average', 'location', 'eastoutside', 'fontsize', 12)
%title('$$\varepsilon_{y}$$ vs $$\varepsilon_{x}$$ (Aluminum)', 'interpreter', 'latex', 'fontsize', 26);
xlabel('$$\varepsilon_{x}$$ (in)', 'interpreter', 'latex', 'fontsize', 20);
ylabel('$$\varepsilon_{y}$$ (in)', 'interpreter', 'latex', 'fontsize', 20);
saveas(1, 'plots_combined\Aluminum Strain.png')

% Plot stess strain curve
young = avg_astress_y/avg_astrain_y;
young_al = mean(young(:,5));
figure(2)
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
hold on
plot(astrain_y(:,1), astress_y(:,1))
plot(astrain_y(:,2), astress_y(:,2))
plot(avg_astrain_y, avg_astress_y)
grid on
hold off
legend('Strain Gauge 1', 'Strain Gauge 2', 'Average', 'location', 'eastoutside', 'fontsize', 12)
%title('$$\sigma_{y}$$ vs $$\varepsilon_{y}$$ (Aluminum)', 'interpreter', 'latex', 'fontsize', 26);
xlabel('$$\varepsilon_{y}$$ (in)', 'interpreter', 'latex', 'fontsize', 20);
ylabel('$$\sigma_{y}$$ (psi)', 'interpreter', 'latex', 'fontsize', 20);
saveas(2, 'plots_combined\Aluminum Young Curve.png')

% Plot tangential stress strain curve
G_al_slope = avg_stress_ys/avg_gamma_ys;
G_al_calc = young_al/(2*(1+poisson_al));
figure(3)
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
hold on
plot(avg_agamma_ys, avg_astress_ys)
grid on
hold off
%legend('Strain Gauge 1', 'Strain Gauge 2', 'Average', 'location', 'eastoutside', 'fontsize', 12)
%title('$$\sigma_{ys}$$ vs $$\gamma_{ys}$$ (Aluminum)', 'interpreter', 'latex', 'fontsize', 26);
xlabel('$$\gamma_{ys}$$ (psi)', 'interpreter', 'latex', 'fontsize', 20);
ylabel('$$\sigma_{ys}$$ (in)', 'interpreter', 'latex', 'fontsize', 20);
saveas(3, 'plots_combined\Aluminum G Curve.png')

% Calc poisson ratio using E, G_avg
G_avg = mean([G_al_slope G_al_calc]);
poisson_al_calc = young_al/(2*G_avg) - 1;


%% Print calculations for aluminum
disp('ALUMINUM:');
disp(sprintf('E = %0.15g psi', young_al));
disp(sprintf('v_slope = %0.15g', poisson_al));
disp(sprintf('v_calc = %0.15g', poisson_al_calc));
disp(sprintf('G_slope = %0.15g psi', G_al_slope));
disp(sprintf('G_calc = %0.15g psi', G_al_calc));
disp(sprintf('J = %0.15g in^4', J_al));
disp(sprintf('strain_x = %s micro inch', mat2str(astrain_x*1000000)));
disp(sprintf('strain_y = %s micro inch', mat2str(astrain_y*1000000)));
disp(sprintf('gamma_xy = %s psi', mat2str(round(agamma_xy,4))));
disp(sprintf('stress_y = %s psi', mat2str(round(astress_y,4))));
disp(sprintf('Mx = %s in-lbf', mat2str(aM_x)));
disp(sprintf('My = %s in-lbf', mat2str(round(avg_aM_y,4))));
disp(sprintf('stress_ys = %s psi', mat2str(round(avg_astress_ys,4))));
disp(sprintf('alpha = %s deg/in', mat2str(round(alpha_al,6))));
disp(sprintf('theta = %s degrees', mat2str(round(theta_beam_al,6))));

%% Calculations for Aluminum 
% Define empty arrays
astrain_x = [];
astrain_y = [];
agamma_xy = [];
astress_y = [];
astress_ys = [];
agamma_ys = [];
aM_x      = [];
aM_y      = [];
avg_astrain_x = [];
avg_astrain_y = [];
avg_agamma_xy = [];
avg_astress_y = [];
avg_astress_ys = [];
avg_agamma_ys = [];
avg_aM_x      = [];
avg_aM_y      = [];
avg_aalpha    = [];

% Iterate through each load to do calculations
for i = 1:size(loadP)
    load = loadP(i);
    poisson = 0.3039;       % calculated poisson
    youngs = 5.4318e+06;    % calculated young's modulus
    G = youngs/(2*(1+poisson));
    thick = cp_thick;
    ri = diam/2 - thick;
    ro = diam/2;
    
    % Calculate the strain in x and y
    sg1 = sg_cp_bendtor(i, 1:3);
    sg2 = sg_cp_bendtor(i, 4:6);
    gamma_xy1 = sg1(1) - sg1(3);
    gamma_xy2 = sg2(1) - sg2(3);
    strain_x1 = sg1(1) + sg1(3) - sg1(2);
    strain_x2 = sg2(1) + sg2(3) - sg2(2);
    strain_y1 = sg1(2);
    strain_y2 = sg2(2);
    avg_gamma_xy = mean([gamma_xy1, gamma_xy2]);
    avg_strain_x = mean([strain_x1, strain_x2]);
    avg_strain_y = mean([strain_y1, strain_y2]);
    
    % Calculate magnitude of moment at each rosette and I_xx
    M_x1 = load * (dist_sg1 - dist_force);
    M_x2 = load * (dist_sg2 - dist_force);
    I_xx = pi/4 * (ro^4 - ri^4);
    avg_M_x = mean([M_x1 M_x2]);
    
    % Solve for bending stress at each rosette
    stress_y1 = M_x1/I_xx * ro;
    stress_y2 = M_x2/I_xx * ro; 
    avg_stress_y = mean([stress_y1 stress_y2]);
    
    % Compute twisting moment given the combined load
    % Note sigma_sy = sigma_xy and gamma_sy = gamma_xy
    stress_ys1 = G * gamma_xy1;
    stress_ys2 = G * gamma_xy2;
    gamma_ys1 = gamma_xy1;
    gamma_ys2 = gamma_xy2;
    M_y1 = stress_ys1*2*thick*pi/4*(ri+ro)^2;
    M_y2 = stress_ys2*2*thick*pi/4*(ri+ro)^2;
    avg_stress_ys = mean([stress_ys1 stress_ys2]);
    avg_gamma_ys = mean([gamma_ys1 gamma_ys2]);
    avg_M_y = mean([M_y1 M_y2]);
    
    % Copmute alpha of beam under combined load
    J = pi/2 * (ro^4 - ri^4);
    alpha1 = M_y1/(G*J);
    alpha2 = M_y2/(G*J);
    avg_alpha = mean([alpha1 alpha2]);
    
    
    % Store all data to arrays
    astrain_x = [astrain_x; strain_x1, strain_x2];
    astrain_y = [astrain_y; strain_y1, strain_y2];
    astress_y = [astress_y; stress_y1, stress_y2];
    agamma_xy = [agamma_xy; gamma_xy1, gamma_xy2];
    astress_ys = [astress_ys; stress_ys1, stress_ys2];
    agamma_ys = [agamma_ys; gamma_ys2, gamma_ys2];
    aM_x      = [aM_x; M_x1, M_x2];
    aM_y      = [aM_y; M_y1, M_y2];
    avg_astrain_x = [avg_astrain_x; avg_strain_x];
    avg_astrain_y = [avg_astrain_y; avg_strain_y];
    avg_astress_y = [avg_astress_y; avg_stress_y];
    avg_agamma_xy = [avg_agamma_xy; avg_gamma_xy];
    avg_astress_ys = [avg_astress_ys; avg_stress_ys];
    avg_agamma_ys = [avg_agamma_ys; avg_gamma_ys];    
    avg_aM_x      = [avg_aM_x; avg_M_x];
    avg_aM_y      = [avg_aM_y; avg_M_y];
    avg_aalpha     = [avg_aalpha; avg_alpha];
end

% Calc angle of end of beam
alpha_cp = rad2deg(avg_aalpha);                % degrees/inch
theta_beam_cp = length * alpha_cp;             % degrees
J_cp = J;

%% Plots for Composite
% Plot strain curve
poisson = -avg_astrain_x/avg_astrain_y;
poisson_cp = mean(poisson(:,5));
figure(4)
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
hold on
plot(astrain_y(:,1), astrain_x(:,1))
plot(astrain_y(:,2), astrain_x(:,2))
plot(avg_astrain_y, avg_astrain_x)
grid on
hold off
legend('Strain Gauge 1', 'Strain Gauge 2', 'Average', 'location', 'eastoutside', 'fontsize', 12)
%title('$$\varepsilon_{y}$$ vs $$\varepsilon_{x}$$ (Composite)', 'interpreter', 'latex', 'fontsize', 26);
xlabel('$$\varepsilon_{x}$$ (in)', 'interpreter', 'latex', 'fontsize', 20);
ylabel('$$\varepsilon_{y}$$ (in)', 'interpreter', 'latex', 'fontsize', 20);
saveas(4, 'plots_combined/Composite Strain.png')

% Plot stess strain curve
young = avg_astress_y/avg_astrain_y;
young_cp = mean(young(:,5));
figure(5)
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
hold on
plot(astrain_y(:,1), astress_y(:,1))
plot(astrain_y(:,2), astress_y(:,2))
plot(avg_astrain_y, avg_astress_y)
grid on
hold off
legend('Strain Gauge 1', 'Strain Gauge 2', 'Average', 'location', 'eastoutside', 'fontsize', 12)
%title('$$\sigma_{y}$$ vs $$\varepsilon_{y}$$ (Composite)', 'interpreter', 'latex', 'fontsize', 26);
xlabel('$$\varepsilon_{y}$$ (in)', 'interpreter', 'latex', 'fontsize', 20);
ylabel('$$\sigma_{y}$$ (psi)', 'interpreter', 'latex', 'fontsize', 20);
saveas(5, 'plots_combined\Composite Young Curve.png')

% Plot tangential stress strain curve
G_cp_slope = avg_stress_ys/avg_gamma_ys;
G_cp_calc = young_cp/(2*(1+poisson_al));
figure(6)
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
hold on
plot(avg_agamma_ys, avg_astress_ys)
grid on
hold off
%legend('Strain Gauge 1', 'Strain Gauge 2', 'Average', 'location', 'eastoutside', 'fontsize', 12)
%title('$$\sigma_{ys}$$ vs $$\gamma_{ys}$$ (Composite)', 'interpreter', 'latex', 'fontsize', 26);
xlabel('$$\gamma_{ys}$$ (psi)', 'interpreter', 'latex', 'fontsize', 20);
ylabel('$$\sigma_{ys}$$ (in)', 'interpreter', 'latex', 'fontsize', 20);
saveas(6, 'plots_combined\Composite G Curve.png')

% Calc poisson ratio using E, G_avg
G_avg = mean([G_cp_slope G_cp_calc]);
poisson_cp_calc = young_cp/(2*G_avg) - 1;


%% Print calculations for composite
disp('COMPOSITE:');
disp(sprintf('E = %0.15g psi', young_cp));
disp(sprintf('v_slope = %0.15g', poisson_cp));
disp(sprintf('v_calc = %0.15g', poisson_cp_calc));
disp(sprintf('G_slope = %0.15g psi', G_cp_slope));
disp(sprintf('G_calc = %0.15g psi', G_cp_calc));
disp(sprintf('J = %0.15g in^4', J_cp));
disp(sprintf('strain_x = %s micro inch', mat2str(astrain_x*1000000)));
disp(sprintf('strain_y = %s micro inch', mat2str(astrain_y*1000000)));
disp(sprintf('gamma_xy = %s psi', mat2str(round(agamma_xy,4))));
disp(sprintf('stress_y = %s psi', mat2str(round(astress_y,4))));
disp(sprintf('Mx = %s in-lbf', mat2str(aM_x)));
disp(sprintf('My = %s in-lbf', mat2str(round(avg_aM_y,4))));
disp(sprintf('stress_ys = %s psi', mat2str(round(avg_astress_ys,4))));
disp(sprintf('alpha = %s deg/in', mat2str(round(alpha_cp,6))));
disp(sprintf('theta = %s degrees', mat2str(round(theta_beam_cp,6))));
