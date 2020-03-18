clear, clc
%% Insert provided data below:
A = [-0.70 0.30; -0.20 -0.40];
B = [0.10; 0.20];
C = [0.20 -0.30];
r = 4.70;
t0 = 0.10;
x0 = [-0.05; 0.11];

%% Calculations -- do not modify
Q = mat2str(C' * C)
R = r