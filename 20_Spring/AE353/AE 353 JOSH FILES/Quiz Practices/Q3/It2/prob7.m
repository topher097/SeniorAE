clear, clc

A = [0.30 0.10 -0.70; -0.30 0.60 0.70; 0.40 0.30 -0.50];
B = [-0.80; 0.00; 0.30];
C = [0.00 0.10 -0.40];
p = [-6.58 -3.17 -8.71];

L = mat2str(acker(A', C', p)')