clear, clc
%% Insert provided data below:
A = [-0.20 0.50 0.80; -0.30 0.10 0.60; 0.70 0.30 0.50];
B = [-0.40; 0.50; 0.20];
C = [-0.60 -0.50 0.90];
r = 3.20;
t0 = 0.40;
x0 = [-0.48; 0.68; -0.35];

%% Calculations -- do not modify
Q = mat2str(C' * C)
R = r