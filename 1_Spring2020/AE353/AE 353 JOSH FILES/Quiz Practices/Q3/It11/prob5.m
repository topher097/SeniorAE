clear , clc

A = [0.50 -0.80 0.90 -0.50; -0.10 -0.80 0.90 0.50; 0.50 0.00 -0.60 0.90; -0.50 0.20 -0.50 -0.30];
B = [0.90; -0.40; 0.60; 0.60];
C = [0.20 0.50 0.80 0.90];
K = [-4.50 -16.30 22.60 -15.60];
L = [-50.00; -8.20; 8.60; 15.40];

kRef = inv(-C*inv(A-B*K)*B);

F = mat2str([A-B*K, -B*K; zeros(length(A)), A-L*C])
G = mat2str([B*kRef; zeros(length(B*kRef), 1)])
H = mat2str([C, zeros(1, length(C))])
