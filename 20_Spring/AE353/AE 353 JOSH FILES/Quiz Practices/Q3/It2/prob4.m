clear, clc

A = [0.60 0.10 -0.30; 0.60 -0.10 -0.60; 0.90 -0.70 0.80];
B = [0.70 0.80; -0.10 0.70; 0.00 0.80];
C = [0.70 0.30 -0.50];
Qo = [1.60];
Ro = [2.70 0.05 -0.70; 0.05 3.90 0.05; -0.70 0.05 2.80];

L = mat2str(lqr(A', C', inv(Ro), inv(Qo))')