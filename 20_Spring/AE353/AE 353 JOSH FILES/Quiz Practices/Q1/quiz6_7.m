clear,clc

A = [-0.8 -0.5 0.7 0.9; 0.4 0.0 0.1 0.4; 0.7 -0.9 0.2 -0.2; -0.6 0.8 -0.2 0.3];
B = [-0.2; -0.5; 0.0; 0.9];
C = [-0.2 0.8 0.9 -0.7];
D = [0.0];
K = [-12.3 143.2 -36.0 85.7];

F = -C*inv(A-B*K)*B