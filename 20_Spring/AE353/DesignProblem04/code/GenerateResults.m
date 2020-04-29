%% Design Problem 4
clc;
clear all;
close all;

% Definitions
tStop = 2;                  % Seconds
initial = [0;0;0;0;0;0;0];  % [x z theta phi phidot v w]
datafile = 'data.mat';  
disp = true;                % Display boolean

% Run Design Problem 4
DesignProblem04('Controller', 'initial', initial, 'seed', 1, 'roadfile', 'road.mat', 'tStop', tStop, 'display', disp);