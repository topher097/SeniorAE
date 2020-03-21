clear all;
close all;
clc;

% Define initial conditions and parameters for controller
tstop = 20;
zeta_o = 0;
theta_o = 0;
zetadot_o = 0;
thetadot_o = 0;
initial = [zeta_o; theta_o; zetadot_o; thetadot_o];
datafile = 'data.mat';
flat_bool = false;       % Flat ground
disp_bool = false;       % Display the simulation 

% Define objects in [data] to save
dat_save = {'step_function','zeta_e','theta_e','zetadot_e','thetadot_e','tau_e','kInt'};

% Run iterations of the design problem 
kInt_iter = {'1'}%,'5','10'}%,'20','30','50'};
t = [];
zeta = [];
theta = [];
zetadot = [];
thetadot = [];
tau = [];
zeta_e = [];
theta_e = [];
zetadot_e = [];
thetadot_e = [];
tau_e = [];
kInt = [];


for p = 1:length(kInt_iter)
kInt_i = str2double(kInt_iter{p});
% Run the design problem 2
disp('start')
tic;
DesignProblem02(sprintf('Controller_%.15g',kInt_i),'initial',initial,'tstop',tstop,'datafile',datafile,'diagnostics',true,'flatground',flat_bool,'display',disp_bool,'controllerdatatolog',dat_save);
disp('ran')
toc
tic;
% Get data from state feedback run
FileData = load(datafile);
t = [t; FileData.controllerdata.sensors.t];
zeta = [zeta; FileData.controllerdata.sensors.zeta];
theta = [theta; FileData.controllerdata.sensors.theta];
zetadot = [zetadot; FileData.controllerdata.sensors.zetadot];
thetadot = [thetadot; FileData.controllerdata.sensors.thetadot];
tau = [tau; FileData.controllerdata.actuators.tau];
zeta_e = [zeta_e; FileData.controllerdata.data.zeta_e];
theta_e = [theta_e; FileData.controllerdata.data.theta_e];
zetadot_e = [zetadot_e; FileData.controllerdata.data.zetadot_e];
thetadot_e = [thetadot_e; FileData.controllerdata.data.thetadot_e];
tau_e = [tau_e; FileData.controllerdata.data.tau_e];
kInt = [kInt; FileData.controllerdata.data.kInt(1)];
toc
end

% Calculate the desired position
tic;
zeta_des = [];
theta_des = [];
zetadot_des = [];
thetadot_des = [];
tau_des = [];
syms t_s real
step_function = FileData.controllerdata.data.step_function(1);
for p = 1:length(kInt_iter)
    zeta_des_i = [];
    theta_des_i = [];
    zetadot_des_i = [];
    thetadot_des_i = [];
    tau_des_i = [];
    for i = 1:length(t)
        zeta_d = round(double(vpa(subs(step_function, t_s, t(i)),5)), 5);
        zeta_des_i = [zeta_des_i, zeta_d+zeta_e(p,i)];
        theta_des_i = [theta_des_i, theta_e(p,i)];
        zetadot_des_i = [zetadot_des_i, zetadot_e(p,i)];
        thetadot_des_i = [thetadot_des_i, thetadot_e(p,i)];
        tau_des = [tau_des_i, tau_e(p,i)];
    end
    zeta_des = [zeta_des; zeta_des_i];
    theta_des = [theta_des; theta_des_i];
    zetadot_des = [zetadot_des; zetadot_des_i];
    thetadot_des = [thetadot_des; thetadot_des_i];
    tau_des = [tau_des; tau_des_i];
end

% Calculate the sum-squared error of system
ss_error = [];
for p = 1:length(kInt_iter)
    ss_error_p = [];
    for i = 1:length(t)
        ss_zeta = (zeta(p,i) - zeta_e(p,i))^2;
        ss_theta = (thetadot(p,i) - thetadot_e(p,i))^2;
        ss_zetadot = (zetadot(p,i) - zetadot_e(p,i))^2;
        ss_thetadot = (thetadot(p,i) - thetadot_e(p,i))^2;
        ss_tau = (tau(p,i) - tau_e(p,i))^2;
        ss_error_i = sqrt(ss_zeta + ss_theta + ss_zetadot + ss_thetadot + ss_tau);
        ss_error_p = [ss_error_p, ss_error_i];
    end
    ss_error = [ss_error; ss_error_p];
end

% % Plot the data over time
figure(4)
hold on
ylim([-4, 4]);
xlim([0,t(end)]);
set(gcf,'position',[100,100,1000,600])      % Change figure size
xlabel('Seconds')
ylabel('Unit (m, rad, N-m)')
err_lw = 1;
des_lw = .75;
plot(t, zeta, 'Linewidth', err_lw);
plot(t, zeta_des_i, '--', 'Linewidth', des_lw);
plot(t, theta, 'Linewidth', err_lw);
plot(t, tau, 'Linewidth', err_lw);
legend({'zeta', 'zeta desired', 'theta', 'tau'},'FontSize',12,'Location','eastoutside');
hold off
% saveas(gcf, sprintf('plots\\data_%.15g.png', 1))

% Plot the sum-squared error over time
figure(2)
hold on
%ylim([abs(min(ss_error))*-1.1, abs(max(ss_error))*1.01]);
ylim([-1, 3]);
xlim([0,t(end)]);
set(gcf,'position',[100,100,1000,600])      % Change figure size
xlabel('Seconds')
ylabel('Sum-Squared Error')
err_lw = 1;
for p = 1:length(kInt_iter)
    plot(t, ss_error(p,:), 'Linewidth', err_lw);
end
plot(t, zeros(1,length(t)), 'k--');
plot(t, 3*ones(1,length(t)), 'k--');
legend(flip(kInt_iter),'FontSize',12,'Location','northeast');
hold off
%saveas(gcf, sprintf('plots\\ss_error.png', 1))

% Plot the zeta error over time
figure(3)
hold on
zeta_error = zeta_des-zeta;
ylim([-2, 2]);
%ylim([abs(min(zeta_error))*-1.1, abs(max(zeta_error))*1.01]);
xlim([0,t(end)]);
set(gcf,'position',[100,100,1000,600])      % Change figure size
xlabel('Seconds')
ylabel('Zeta Error (m)')
err_lw = 1;
for p = 1:length(kInt_iter)
    plot(t, zeta_error(p,:), 'Linewidth', err_lw);
end
plot(t, zeros(1,length(t)), 'k--');
plot(t, ones(1,length(t))*0.75, 'k--');
plot(t, ones(1,length(t))*-0.75, 'k--');
legend(flip(kInt_iter),'FontSize',12,'Location','northeast');
hold off
%saveas(gcf, sprintf('plots\\zeta_error.png', 1))

toc