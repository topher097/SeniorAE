clear, clc
%% Insert Provided data here:
A = [0.70 0.40 0.30 -0.90; -0.90 -0.20 0.70 -0.20; -0.70 0.30 0.60 0.30; 0.70 0.00 0.00 0.00];
B = [0.80; -0.90; -0.90; 0.40];
C = [-0.30 -0.20 -0.80 0.00];
K = [-5.30 2.80 -12.80 7.50];
L = [8.00; -14.50; -6.60; -6.80];

%% Calculations:
kRef = kRef(A,B,C,K);

[m, n] = size(C);

F = [A -B*K; L*C A-B*K-L*C];
G = [B*kRef; B*kRef];
H = [C zeros(1,n)];

F = mat2str(F)
G = mat2str(G)
H = mat2str(H)