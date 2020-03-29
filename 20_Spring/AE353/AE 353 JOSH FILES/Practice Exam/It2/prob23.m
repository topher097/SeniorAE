clear, clc

A = [0.20 0.90 0.00; 0.40 0.30 -0.20; 0.10 -0.50 0.00];
B = [0.50; 0.70; 0.80];
C = [-0.20 0.80 -0.10];
K = [4.70 8.80 -4.80];
L = [21.80; 12.40; 19.40];

kRef = inv(-C*inv(A-B*K)*B);

F = [A-B*K, -B*K; zeros(size(A)), A-L*C];
G = [B*kRef; zeros(length(B*kRef), 1)];
H = [C, zeros(1, length(C))];

F = mat2str(F)
G = mat2str(G)
H = mat2str(H)