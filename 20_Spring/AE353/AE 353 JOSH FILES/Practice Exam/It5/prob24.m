clear, clc

A = [-0.2 -0.6 0.5 -0.6; 0.0 -0.9 -0.4 0.6; 0.8 -0.1 0.3 0.2; -0.9 0.7 -0.7 0.0];
B = [0.9; 0.6; 0.2; 0.3];
C = [-0.4 -0.4 -0.9 0.4];
L1 = [-4918.4; -1323.5; 4513.3; 3979.3];
L2 = [2074.2; 637.7; -2045.0; -1864.4];
L3 = [-207.2; -105.0; 129.2; 8.9];
L4 = [3517.2; 1456.9; -3086.2; -2000.3];
L5 = [163.3; 62.1; -91.4; 13.9];

stab1 = eig(A-L1*C)
stab2 = eig(A-L2*C)
stab3 = eig(A-L3*C)
stab4 = eig(A-L4*C)
stab5 = eig(A-L5*C)