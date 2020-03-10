clear, clc

A = [0.10 0.70; 0.20 -0.50];
B = [0.20; 0.10];
C = [-0.50 0.30];
K = [4.20 4.60];
L = [-26.30; -20.20];

kRef = inv(-C*inv(A-B*K)*B);

F = [A, -B*K; L*C, A-B*K-L*C]
G = [B*kRef; B*kRef]
H = [C zeros(1, length(C))]

% F = mat2str(F)
% G = mat2str(G)
% H = mat2str(H)