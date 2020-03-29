clear, clc
%% Insert Provided Data
A = [0.9 0.0 0.3; 0.9 0.9 -0.7; 0.2 -0.7 0.6];
B = [0.8; -0.8; 0.3];
C = [0.2 0.8 0.9];
D = [0.0];
K = [132.4 98.6 -62.4];

%% Calculations
kRef = inv(-C*inv(A-B*K)*B);
E = mat2str(A-B*K)
F1 = mat2str(B*kRef)
F2 = mat2str(B)
G = mat2str(C-D*K)
H1 = mat2str(D*kRef)
H2 = mat2str(D)