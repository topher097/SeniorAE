clear,clc

A = [0.2 -0.9 -0.4; 0.5 0.9 0.8; 0.2 -0.7 0.4];
B = [0.6; 0.7; 0.9];
C = [0.4 -0.4 0.9];
D = [0.0];
K = [8.8 9.4 -8.0];

F = (C)*(-inv(A-B*K))*B