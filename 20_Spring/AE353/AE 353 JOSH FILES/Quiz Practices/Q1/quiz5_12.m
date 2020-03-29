clear, clc

DesignProblem00('Controller', 'datafile', 'DATA.mat', 'initial', [1.8; -0.6], 'display' ,false)

load('DATA.mat')

figure(1)
plot(processdata.t, processdata.z)

figure(2)
plot(processdata.t, processdata.zdot)