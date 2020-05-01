%% AE461 Prelab 5
clc;
clear all;
close all;

%% Material Properties
% Mild steel
ms_E = 215.3e9;         % Pa
ms_rho = 8000;          % kg/m^3

% Copper
cu_E = 129e9;           % Pa
cu_rho = 8890;          % kg/m^3

%% Problem 1
L = 18*0.0254;          % m
b = 1.5*.0254;          % m
h = .25*.0254;          % m
V = b*h*L;              % m^3

ms_m = ms_rho * V;      % kg
cu_m = cu_rho * V;      % kg

% Area moments of inertia of bar
Izz = (h*b^3)/12;       % m^4 
Iyy = (b*h^3)/12;       % m^4


