clear, close all, clc

DesignProblem00('Controller', 'datafile', 'File.mat', 'initial', [-2.5; 0.1], 'display', false)

load('File.mat');
figure(1)
plot(processdata.t, processdata.z)

figure(2)
plot(processdata.t, processdata.zdot)
