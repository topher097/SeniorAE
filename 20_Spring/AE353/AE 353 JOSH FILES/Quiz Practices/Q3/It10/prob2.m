clear, clc

A = [-0.30 -0.70 -0.60; -0.80 -0.20 -0.20; -0.50 0.90 -0.10];
B = [0.10; 0.80; -0.10];
C = [-0.90 -0.70 -0.80];
K = [37.40 2.20 41.70];
L = [111.00; -1.00; -133.60];

kRef = inv(-C*inv(A-B*K)*B);

F = [A-B*K, -B*K; zeros(length(A)), A-L*C];
G = [B*kRef; zeros(length(B*kRef), 1)];
H = [C, zeros(1, length(C))];

F = mat2str(F)
G = mat2str(G)
H = mat2str(H)