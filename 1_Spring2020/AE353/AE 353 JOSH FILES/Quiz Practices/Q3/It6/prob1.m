clear, clc

A = [0.70 -0.70; -0.40 0.30];
B = [0.40; 0.70];
C = [-0.30 -0.30];
K = [-16.80 14.90];
L = [-104.80; 87.40];

kRef = inv(-C*inv(A-B*K)*B);

F = [A-B*K, -B*K; zeros(size(A)), A-L*C];
G = [B*kRef; zeros(length(B*kRef), 1)];
H = [C, zeros(1, length(C))];

F = mat2str(F)
G = mat2str(G)
H = mat2str(H)