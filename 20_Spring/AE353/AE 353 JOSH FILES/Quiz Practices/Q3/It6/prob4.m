clear, clc

A = [-0.70 0.80; 0.90 -0.90];
B = [-0.60; 0.10];
C = [0.50 -1.00];
Qo = [0.60];
Ro = [2.90 0.50; 0.50 2.70];

L = mat2str(lqr(A', C', inv(Ro), inv(Qo))')