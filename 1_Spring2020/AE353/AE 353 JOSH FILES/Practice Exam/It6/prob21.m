clear, clc

A = [-0.7 0.3 0.0 -0.3; 0.7 0.0 0.0 0.6; 0.5 0.9 -0.3 0.7; -0.2 -0.9 0.3 0.1];
B = [-0.4; -0.4; 0.5; -0.4];
C = [0.7 0.7 0.9 -0.5];
L1 = [-1774.3; 570.3; 1381.7; 800.4];
L2 = [-4271.9; 1159.7; 4212.8; 3197.9];
L3 = [-3981.8; 956.6; 4521.9; 3841.3];
L4 = [175.3; 86.0; -571.3; -675.0];
L5 = [-52.7; -46.7; 187.2; 206.7];

stab1 = eig(A-L1*C)
stab2 = eig(A-L2*C)
stab3 = eig(A-L3*C)
stab4 = eig(A-L4*C)
stab5 = eig(A-L5*C)