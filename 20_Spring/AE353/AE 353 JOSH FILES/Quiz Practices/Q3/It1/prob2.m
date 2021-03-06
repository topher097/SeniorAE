clear, clc
A = [-0.9 -0.9 -0.6 0.9; -0.3 -0.3 0.6 -0.2; 0.4 0.3 0.5 -0.7; 0.4 -0.9 -0.4 -0.9];
B = [0.7; 0.4; -0.9; 0.8];
C = [-0.7 0.8 0.7 0.5];
L1 = [502.5; 335.4; -34.5; 208.8];
L2 = [41.1; -4.8; 41.2; 28.5];
L3 = [-17330.2; -24057.0; 12469.2; -3216.4];
L4 = [-3127.3; -4753.0; 2588.5; -409.0];
L5 = [-13616.0; -22867.1; 13125.7; -871.5];

stab1 = eig(A-L1*C)
stab2 = eig(A-L2*C)
stab3 = eig(A-L3*C)
stab4 = eig(A-L4*C)
stab5 = eig(A-L5*C)