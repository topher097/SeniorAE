clear, clc

DesignProblem00('Controller', 'datafile', 'Data.mat', 'initial', [-1.5; 0.8], 'display', false);

load('Data.mat');

figure(1)
plot(processdata.t, processdata.z)

figure(2)
plot(processdata.t, processdata.zdot)