clear, clc

A = [0.70 0.80 0.40 -0.80; -0.50 0.80 -0.90 0.30; 0.50 -0.70 -0.60 -0.10; -0.60 0.00 0.00 0.20];
B = [-0.40 0.40 1.00; 0.60 -0.20 0.30; 0.70 -0.80 -0.90; 1.00 -0.50 0.10];
C = [0.50 0.90 -0.50 -0.90; -0.30 0.40 1.00 -0.40];
Qo = [2.90 -0.05; -0.05 2.60];
Ro = [3.20 0.40 0.65 -0.20; 0.40 4.10 -0.10 0.10; 0.65 -0.10 3.10 -0.15; -0.20 0.10 -0.15 4.00];

L = mat2str(lqr(A', C', inv(Ro), inv(Qo))')