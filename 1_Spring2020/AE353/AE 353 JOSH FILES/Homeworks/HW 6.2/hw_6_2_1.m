clear, clc
%% Insert Provided data here:
A = [-0.80 0.50 -0.40; -0.20 0.00 0.10; -0.70 -0.30 -0.70];
B = [-0.60; -0.90; 0.40];
C = [-0.40 0.10 0.80];
K = [11.90 -4.30 19.00];
L = [-10.90; -37.00; 8.90];

%% Calculations:

kRef = -1/(C*inv(A-B*K)*B);

[m, n] = size(C);

F = [A -B*K; L*C A-B*K-L*C];
G = [B*kRef; B*kRef];
H = [C zeros(1,n)];

F = mat2str(F)
G = mat2str(G)
H = mat2str(H)