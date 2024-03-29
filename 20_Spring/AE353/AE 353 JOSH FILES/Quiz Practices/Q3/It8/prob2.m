clear, clc

A = [-0.9 -0.4 -0.6; -0.7 0.8 0.2; 0.6 -0.1 0.3];
B = [0.2; 0.1; 0.5];
C = [-0.1 0.8 0.0];
L1 = [-395.3; -36.4; -722.0];
L2 = [-147.4; -34.4; 22.1];
L3 = [-30.4; 11.8; 76.5];
L4 = [-16.7; 9.0; 36.7];
L5 = [-26.3; 12.8; 96.4];

stab1 = eig(A-L1*C)
stab2 = eig(A-L2*C)
stab3 = eig(A-L3*C)
stab4 = eig(A-L4*C)
stab5 = eig(A-L5*C)