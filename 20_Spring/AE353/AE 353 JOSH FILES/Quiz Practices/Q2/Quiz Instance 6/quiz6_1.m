clear, clc
A = [0.40 0.90; 0.50 0.40];
B = [0.60; 0.40];
C = [-0.40 -0.30];
D = [0.00];
p = [-3.54-2.04j -3.54+2.04j];

K = acker(A,B,p); K = mat2str(K)