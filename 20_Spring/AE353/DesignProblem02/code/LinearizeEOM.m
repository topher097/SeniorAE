clc;
clear all;

% Load the equations of motion
load('eom.mat');
% Parse the equations of motion
f = symEOM.f;
% Define symbolic variables that appear in the equations of motion
syms zeta zetadot theta thetadot tau real
% Proceed to linearize or do whatever else you like...
disp(f)
%	(see: help sym/jacobian, help sym/diff, help sym/subs, etc.)