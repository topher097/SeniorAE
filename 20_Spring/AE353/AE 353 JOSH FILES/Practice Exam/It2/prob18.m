clear, clc

A = [-1.00 0.70; 0.40 -0.50];
B = [-0.70; 0.10];
Q = [2.70 0.05; 0.05 2.80];
R = [0.70];
t0 = 0.80;
x0 = [0.14; -0.01];

[K, P] = lqr(A, B, Q, R); K = mat2str(K)