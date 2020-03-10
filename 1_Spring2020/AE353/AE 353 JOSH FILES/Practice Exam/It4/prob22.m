clear, clc
%% Insert provided data
A = [0.2 0.4 0.8; -0.4 -0.8 0.2; 0.9 -0.8 -0.6];
B = [-0.6; -0.7; -0.4];
C = [-0.6 0.4 -0.3];
L1 = [-13.0; -36.9; -50.6];
L2 = [-117.1; 119.6; 402.9];
L3 = [29.6; -31.3; -80.5];
L4 = [-326.8; -68.8; 593.6];
L5 = [-232.1; -9.6; 465.4];

%% Calculations
stab1 = eig(A-C*L1)
stab2 = eig(A-C*L2)
stab3 = eig(A-C*L3)
stab4 = eig(A-C*L4)
stab5 = eig(A-C*L5)
