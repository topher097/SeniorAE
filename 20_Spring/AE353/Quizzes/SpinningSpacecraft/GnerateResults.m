clc;
clear all;
close all;


x0 = [0.08; 0.46; 0.33];
t1 = 1.64;

Simulator('Controller', 'tStop', t1, 'initial', x0)
