clc;
clear all;
close all;
tStop = 1;

Simulator('Controller', 'tStop', tStop, 'eomfile', 'eom.mat')