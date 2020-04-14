clear, clc

A = [-0.90 -0.10 -0.10 0.00; 0.60 0.40 0.40 0.40; -0.70 -0.20 0.10 -0.50; 0.20 -0.20 0.00 0.80];
B = [0.00; -0.60; -0.30; -0.40];
C = [-0.60 -0.40 0.80 -0.40];
p = [-9.34-4.43j -9.34+4.43j -9.49-4.64j -9.49+4.64j];

L = mat2str(acker(A', C', p)')