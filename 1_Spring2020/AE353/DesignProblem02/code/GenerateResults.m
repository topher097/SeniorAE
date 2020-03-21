clear all;
close all;
clc;
%%
% Define initial conditions and parameters for controller
tstop = 30;
zeta_o = 0;
theta_o = 0;
zetadot_o = 0;
thetadot_o = 0;
initial = [zeta_o; theta_o; zetadot_o; thetadot_o];
datafile = 'data.mat';
flat_bool = false;       % Flat ground
disp_bool = false;       % Display the simulation 
ref_eq = @(x) 2*sin(x/10);

% Define objects in [data] to save
dat_save = {'step_function','zeta_e','theta_e','zetadot_e','thetadot_e','tau_e','kInt','K'};
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
K = [];

% Run the design problem 
DesignProblem02('Controller','initial',initial,'reference',ref_eq,'tstop',tstop,'datafile',datafile,'diagnostics',true,'flatground',flat_bool,'display',disp_bool,'controllerdatatolog',dat_save);

% Get data from state feedback run
FileData = load(datafile);
t =  FileData.controllerdata.sensors.t ;
zeta =  FileData.controllerdata.sensors.zeta ;
theta =  FileData.controllerdata.sensors.theta ;
zetadot =  FileData.controllerdata.sensors.zetadot ;
thetadot =  FileData.controllerdata.sensors.thetadot ;
tau =  FileData.controllerdata.actuators.tau ;
zeta_e =  FileData.controllerdata.data.zeta_e ;
theta_e =  FileData.controllerdata.data.theta_e ;
zetadot_e =  FileData.controllerdata.data.zetadot_e ;
thetadot_e =  FileData.controllerdata.data.thetadot_e ;
tau_e =  FileData.controllerdata.data.tau_e ;
kInt =  FileData.controllerdata.data.kInt(1) ;
K = FileData.controllerdata.data.K(:,1)'


%%
% Calculate the desired position
syms t_s real
step_function = FileData.controllerdata.data.step_function(1);
zeta_des = [];
theta_des = [];
zetadot_des = [];
thetadot_des = [];
tau_des = [];
for i = 1:length(t)
    zeta_d = round(double(vpa(subs(step_function, t_s, t(i)),5)), 5);
    zeta_des = [zeta_des, zeta_d+zeta_e(i)];
    theta_des = [theta_des, theta_e(i)];
    zetadot_des = [zetadot_des, zetadot_e(i)];
    thetadot_des = [thetadot_des, thetadot_e(i)];
    tau_des = [tau_des, tau_e(i)];
end

% Calculate the sum-squared error and standard deviationof states
ss_error = [];
n = size(t);
for i = 1:length(t)
    ss_zeta = (zeta(i) - zeta_des(i) - zeta_e(i))^2;
    %ss_theta = (thetadot(i) - thetadot_e(i))^2;
    %ss_zetadot = (zetadot(i) - zetadot_e(i))^2;
    %ss_thetadot = (thetadot(i) - thetadot_e(i))^2;
    %ss_tau = (tau(i) - tau_e(i))^2;
    ss_error_i = (ss_zeta)/n(2);
    ss_error = [ss_error, ss_error_i];
end

standard_deviation = sqrt(sum(ss_error, 'all')/(n(2)-1));
disp(fprintf('Standard Deviation of Zeta Error = %.15g', standard_deviation));

%%
close all;
% Plot the data over time
figure(4)
hold on
ylim([-1.25, 3]);
xlim([0,t(end)*1.05]);
set(gcf,'position',[100,100,1200,300])      % Change figure size
xlabel('Seconds')
ylabel('Unit (m, rad, N-m)')
err_lw = 1;
des_lw = .75;
plot(t, zeta, 'Linewidth', err_lw);
plot(t, zeta_des, '--', 'Linewidth', des_lw);
plot(t, theta, 'Linewidth', err_lw);
plot(t, tau, 'Linewidth', err_lw);
plot(t, zeros(1,length(t)), 'k--');
legend({'Zeta', 'Zeta Desired', 'Theta', 'Tau'},'FontSize',12,'Location','eastoutside');
hold off
saveas(gcf, sprintf('plots\\data.png', 1))

% Plot the sum-squared error over time
figure(2)
hold on
%ylim([-.05, max(ss_error)*1.05]);
%xlim([0,t(end)*1.05]);
set(gcf,'position',[100,100,1200,300])      % Change figure size
xlabel('Sum-Squared Error of Zeta')
ylabel('Frequency')
histogram(ss_error, 50);
%plot(t, zeros(1,length(t)), 'k--');
%plot(t, 3*ones(1,length(t)), 'k--');
legend('Sum-Squared Error','FontSize',12,'Location','eastoutside');
hold off
saveas(gcf, sprintf('plots\\ss_error.png', 1))

% Plot the zeta error over time
figure(3)
hold on
zeta_error = zeta_des-zeta;
ylim([-.35, .35]);
xlim([0,t(end)*1.05]);
set(gcf,'position',[100,100,1200,300])      % Change figure size
xlabel('Seconds')
ylabel('Zeta Error (m)')
err_lw = 1;
plot(t, zeta_error, 'Linewidth', err_lw);
plot(t, zeros(1,length(t)), 'k--');
plot(t, ones(1,length(t))*0.25, 'k--');
plot(t, ones(1,length(t))*-0.25, 'k--');
legend('Zeta Error','FontSize',12,'Location','eastoutside');
hold off
saveas(gcf, sprintf('plots\\zeta_error.png', 1))


%%
syms tau theta zeta thetadot zetadot real
load('eom.mat')
f = symEOM.f;

x = [zeta; zetadot; theta; thetadot];
xdot = [zetadot; f(1); thetadot; f(2)];
u = [tau];

theta_e = 0;
zeta_e = 0;
thetadot_e = 0;
zetadot_e = 0;
tau_e = 0;

% Double turns the symbolic expression into a floating point matrix
A = double(subs(jacobian(xdot, x), [zeta; theta; zetadot; thetadot; tau], [zeta_e; theta_e; zetadot_e; thetadot_e; tau_e]));
B = double(subs(jacobian(xdot, u), [zeta; theta; zetadot; thetadot; tau], [zeta_e; theta_e; zetadot_e; thetadot_e; tau_e]));
C = [1 0 0 0];
D = [0];
    
Q = diag([25, 20, 15, 5]);
R = diag([.1]);
[K, P] = lqr(A, B, Q, R);
kRef = -1/(C*inv(A - B * K)*B);
kInt = -5;
eig_close = eig(A-B*K);
eig_open = eig(A);

%%
% Determine the steady state error given step response (with and without
% disturbance)
G = [C, 0];
E = [A-B*K -B*kInt ; G];
F1 = [B*kRef ; -1];
F1a = [B*kRef+B ; -1];
F2 = [B ;0];
Am = E;
Bm = [F1 F2];
Bma = [F1a F2];
Cm = G;

% No disturbance
sys1 = ss(Am,Bm,Cm,D);
step(sys1)
S1 = stepinfo(sys1, 'SettlingTimeThreshold', 0.05);
s1_risetime = S1.RiseTime;
s1_timetopeak = S1.PeakTime;
s1_overshoot = S1.Overshoot;
s1_settlingtime = S1.SettlingTime;
s1_error = 0;

% Disturbance
sys2 = ss(Am,Bma,Cm,D);
%step(sys2)
S2 = stepinfo(sys2, 'SettlingTimeThreshold', 0.05);
s2_risetime = S2.RiseTime;
s2_timetopeak = S2.PeakTime;
s2_overshoot = S2.Overshoot;
s2_settlingtime = S2.SettlingTime;
s2_error = 0;
disp(S2)


