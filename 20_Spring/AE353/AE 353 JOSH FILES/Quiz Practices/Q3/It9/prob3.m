clear, clc
A = [-0.30 -0.10 -0.70 -0.80; -0.30 -0.40 -0.10 -0.20; 0.10 0.70 0.20 0.70; -0.40 -0.30 -0.70 0.90];
B = [-0.30; 0.50; -0.80; -0.80];
C = [-0.30 0.10 -0.80 -0.80];
K = [1.40 -21.00 -18.90 0.50];
L = [-485.00; 90.40; 243.60; -56.50];

kRef = inv(-C*inv(A-B*K)*B);

F = [A-B*K, -B*K; zeros(size(A)), A-L*C];
G = [B*kRef; zeros(length(B*kRef), 1)];
H = [C, zeros(1, length(C))];

F = mat2str(F)
G = mat2str(G)
H = mat2str(H)