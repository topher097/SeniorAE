%%
clc;
clear all;
close all;

display = false;
roadfile = 'roads\\road_10.mat';
datafile = 'data.mat';
DesignProblem04('Controller', 'display', display, 'roadfile', roadfile, 'datafile', datafile)

load(datafile);
time = processdata.t(end)
finished = processdata.result(end)