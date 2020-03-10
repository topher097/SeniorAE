clear, clc
%% Insert provided data here:
A = [0.00 -0.60; 0.70 -0.60];
B = [0.00; 0.50];
C = [-0.90 0.60];
L = [28.70; 43.40];
x0 = [0.40; -0.60];
xhat0 = [-0.30; 0.40];
t0 = 0.50;
t1 = 1.40;

%% Calculations: do not modify:
e = expm((A-L*C)*(t1 - t0))*(xhat0 - x0)