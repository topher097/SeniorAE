clc;
clear;

A = [-0.9 0.8 -0.6 0.5; 0.5 0.5 -0.5 0.9; -0.4 0.1 0.9 0.6; -0.9 -0.9 -0.6 -0.3];
B = [-0.9; 0.3; 0.6; 0.1];
C = [-0.6 -0.7 -0.3 0.6];
D = [0.0];
K = [-0.5 -5.2 13.3 -6.5];

kref = -1/(C*inv(A-B*K)*B)

