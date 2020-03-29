clear, clc

A = [0.70 0.40; 0.90 -0.40];
B = [0.20; -0.20];
C = [-0.50 -0.90];
K = [10.50 3.00];
L = [-32.00; 8.30];

kRef = inv(-C*inv(A-B*K)*B);

F = mat2str([A-B*K, -B*K; zeros(length(A)), A-L*C])
G = mat2str([B*kRef; zeros(length(B*kRef), 1)])
H = mat2str([C, zeros(1, length(C))])