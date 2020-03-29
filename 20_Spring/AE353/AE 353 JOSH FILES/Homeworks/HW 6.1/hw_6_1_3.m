clear,clc
%% Insert provided data:
A = [-0.1 -0.7; -0.6 -0.1];
B = [0.8; 0.1];
C = [-0.3 0.3];
L1 = [339.3; 364.7];
L2 = [370.0; 360.7];
L3 = [1687.3; 1738.7];
L4 = [454.3; 459.7];
L5 = [-418.3; -441.3];

%% Calculations, do not modify:

% Stable if all real vals are negative
stab1 = eig(A-L1*C)
stab2 = eig(A-L2*C)
stab3 = eig(A-L3*C)
stab4 = eig(A-L4*C)
stab5 = eig(A-L5*C)