clear,clc
%% Insert provided data below:
A = [-0.40 0.10 -0.70; 0.80 -0.70 1.00; -0.30 -0.30 0.60];
B = [-0.60; 0.20; 0.00];
Q = [2.30 -0.45 0.50; -0.45 2.70 -0.30; 0.50 -0.30 2.20];
R = [0.20];
t0 = 0.90;
x0 = [0.51; -0.29; 0.64];

%% Calculations -- do not modify
[K, P] = lqr(A,B,Q,R);
cost = x0'*P*x0