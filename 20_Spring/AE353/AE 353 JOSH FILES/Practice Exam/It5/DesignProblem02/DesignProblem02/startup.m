clear, clc

DesignProblem02('Controller', 'display', false, 'datafile', 'initial.mat', 'tStop', 0.58, 'initial', [0.49; 0.27; -0.32; 0.45])
%%
DesignProblem02('Controller', 'display', false, 'datafile', 'final.mat', 'tStop', 1.76, 'initial', [0.49; 0.27; -0.32; 0.45])

%% Load
load('initial.mat'); load('final.mat');

