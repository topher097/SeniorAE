clear, clc

%% Provided data:
A = [-0.60 0.90; -0.20 -0.90];
B = [0.90; 0.80];
Q = [1.90 -0.25; -0.25 2.70];
R = [1.00];
t0 = 0.90;
x0 = [0.07; 0.71];

%% Calculations:
[K, P] = lqr(A,B,Q,R);
K = mat2str(K)