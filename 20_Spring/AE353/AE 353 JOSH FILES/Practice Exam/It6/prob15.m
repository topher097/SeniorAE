clear, clc

A = [-0.40 -0.50 0.40; -0.70 0.00 0.80; -0.80 0.70 0.60];
B = [-0.30; -0.50; -0.10];
C = [0.10 -0.30 0.90];
D = [0.00];
p = [-1.49-0.31j -1.49+0.31j -2.67+0.00j];

K = mat2str(acker(A,B,p))