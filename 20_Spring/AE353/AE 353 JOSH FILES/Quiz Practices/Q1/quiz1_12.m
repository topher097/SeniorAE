clear,clc

DesignProblem00('Controller', 'datafile','Question12.mat', 'initial', [0.1; -0.1], 'display', false);

load('Question12.mat');
figure(1)
plot(processdata.t, processdata.z)
figure(2)
plot(processdata.t, processdata.zdot)