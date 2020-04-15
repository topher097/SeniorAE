clc;
clear all;
close all;
tStop = 3;

Simulator('Controller', 'tStop', tStop, 'eomfile', 'eom.mat')