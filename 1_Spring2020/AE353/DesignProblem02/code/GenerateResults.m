clear all;
clc;

% Define initial conditions and parameters for controller
tstop = 5;
zeta_o = 0;
theta_o = 0;
zetadot_o = 0;
thetadot_o = 0;
initial = [zeta_o, theta_o, zetadot_o, thetadot_o];
datafile = 'data.mat';
flat_bool = true;       % Flat ground
disp_bool = true:       % Display the simulation

% Define file to save data to
csvfile = 'data.csv';

% Run the design problem 2
DesignProblem02('Controller','initial',initial,'tstop',tstop,'flatground',flat_bool,'display',disp_bool);