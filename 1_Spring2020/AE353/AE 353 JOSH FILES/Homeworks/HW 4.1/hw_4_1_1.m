clear, clc
%% Insert provided values here:
A = [0.10 0.60 0.80; 0.30 -0.20 0.20; -0.80 0.10 0.50];
B = [0.40; 0.60; -0.20];
C = [0.60 0.30 0.00];
D = [0.00];
p = [-6.90+0.00j -1.10-0.52j -1.10+0.52j];

%% Computation (do not modify)
K = mat2str(K_matrix(A,B,p))