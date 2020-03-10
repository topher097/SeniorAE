clear, close all, clc

DesignProblem00('Controller', 'datafile', 'Saved.mat', 'initial', [0.9; 0.9], 'display', false)

load('Saved.mat');

figure(1)
plot(processdata.t, processdata.z)

figure(2)
plot(processdata.t, processdata.zdot)