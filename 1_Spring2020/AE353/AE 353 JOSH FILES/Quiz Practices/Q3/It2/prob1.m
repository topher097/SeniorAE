clear, clc

A = [-0.10 0.00 -0.60 0.10; 0.80 0.60 -0.10 0.10; 0.50 0.90 -0.80 0.80; 0.40 0.80 -0.80 -0.50];
B = [-0.40; 0.50; 0.20; -0.20];
C = [-0.70 0.20 -0.50 -0.10];
K = [-11.80 -2.60 5.00 10.00];
L = [-439.80; 4081.30; 2157.40; 291.90];

kRef = inv(-C*inv(A-B*K)*B);

F = [A-B*K, -B*K; zeros(size(A)), A-L*C];
G = [B*kRef; zeros(length(B*kRef), 1)];
H = [C, zeros(1, length(C))];

F = mat2str(F)
G = mat2str(G)
H = mat2str(H)