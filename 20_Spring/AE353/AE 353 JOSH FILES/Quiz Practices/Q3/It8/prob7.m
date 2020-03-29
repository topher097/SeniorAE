clear, clc

A = [-0.20 0.30; -0.60 -0.40];
B = [-0.50; 0.70];
C = [-0.70 0.70];
K = [3.00 5.30];
L = [-26.60; -19.70];

kRef = inv(-C*inv(A-B*K)*B);

F = [A-B*K, -B*K; zeros(size(A)), A-L*C];
G = [B*kRef; zeros(length(B*kRef), 1)];
H = [C, zeros(1,length(C))];

F = mat2str(F)
G = mat2str(G)
H = mat2str(H)