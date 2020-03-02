clc;
clear all;

tstop = 8;
initial = [2; -2; .1; 0; 0; 0];

DesignProblem01('Controller','tstop',tstop,'initial',initial,'diagnostics',true);

