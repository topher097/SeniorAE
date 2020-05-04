%% Design Problem 4
clc;
clear all;
close all;

% Definitions
tStop = 45;                  % Seconds
initial = [0; 0; 0; 0; 0; 1.75; 0]; % [x z theta phi phidot v w]
datafile = 'data.mat';  
roadfile = 'road.mat';
display = true;                % Display boolean

disp('Running Controller');
% Run Design Problem 4
%DesignProblem04('Controller', 'initial', initial, 'roadfile', roadfile, 'display', disp);
DesignProblem04('Controller', 'roadfile', roadfile, 'tStop', tStop, 'display', display, 'snapshotfile', 'pic.pdf', 'seed', 1);
%DesignProblem04Race('racers', 'road.mat', 'display', disp, 'savedata', true);
%open('pic.pdf');
%140 sec