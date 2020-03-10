clear, clc

A = [-0.60 -0.10 -0.60; 0.50 -0.60 -0.40; -0.80 -0.90 -0.10];
B = [-0.60; -0.20; 0.20];
C = [0.90 -0.70 -0.80];
K = [16.30 -91.50 -26.10];
L = [1.90; 2.80; -4.40];

kRef = inv(-C*inv(A-B*K)*B);

F = mat2str([A-B*K, -B*K; zeros(length(A)), A-L*C])
G = mat2str([B*kRef; zeros(length(B*kRef), 1)])
H = mat2str([C, zeros(1, length(C))])