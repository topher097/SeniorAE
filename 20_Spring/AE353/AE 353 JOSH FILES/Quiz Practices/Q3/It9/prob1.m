clear, clc
A = [0.40 0.80 0.90; 0.40 0.60 0.90; 0.40 0.60 -0.10];
B = [-0.20; 0.20; 0.60];
C = [0.10 0.10 0.80];
p = [-1.13-0.99j -1.13+0.99j -6.61+0.00j];

L = mat2str(acker(A', C', p)')