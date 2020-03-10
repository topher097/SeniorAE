clear all;
close all;
clc;

% Define initial conditions and parameters for controller
tstop = 30;
zeta_o = 0;
theta_o = 0;
zetadot_o = 0;
thetadot_o = 0;
initial = [zeta_o; theta_o; zetadot_o; thetadot_o];
datafile = 'data.mat';
flat_bool = false;       % Flat ground
disp_bool = true;       % Display the simulation 

% Define file to save data to
csvfile = 'data.csv';

% Run the design problem 2
%DesignProblem02('Controller','initial',initial,'tstop',tstop,'datafile',datafile,'diagnostics',true,'flatground',flat_bool,'display',disp_bool);

% Get data from state feedback run
FileData = load(datafile);
t = FileData.controllerdata.sensors.t;
zeta = FileData.controllerdata.sensors.zeta;
theta = FileData.controllerdata.sensors.theta;
zetadot = FileData.controllerdata.sensors.zetadot;
thetadot = FileData.controllerdata.sensors.thetadot;
tau = FileData.controllerdata.actuators.tau;

% Calculate the desired position
zeta_des = [];
syms t_s real
step_function = 3*sin(t_s/5);
for i = 1:length(t)
    zeta_d = subs(step_function, t_s, t(i));
    zeta_des = [zeta_des, zeta_d];
end
disp(zeta_des);
% Plot the data from state-feedback and no-input runs
figure()
hold on
ylim([-6, 4]);
xlim([0,t(end)]);
set(gcf,'position',[100,100,1000,600])      % Change figure size
xlabel('Seconds')
ylabel('Unit (m or rad)')
data_lw = 1;
des_lw = .75;
plot(t, zeta, 'Linewidth', data_lw);
plot(t, zeta_des, '--', 'Linewidth', des_lw);
plot(t, theta, 'Linewidth', data_lw);
plot(t, tau, 'Linewidth', data_lw);
legend({'zeta', 'zeta desired', 'theta', 'tau'},'FontSize',12,'Location','eastoutside');
hold off
saveas(gcf, sprintf('plots\\Iteration_%.15g.png', 1))