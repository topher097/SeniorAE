clear, clc

A = [0.10 0.20 0.70; 0.10 -0.70 0.10; -0.40 0.30 -0.40];
B = [-0.60; -0.60; -0.30];
C = [-0.80 -0.40 0.60];
K = [-32.30 41.40 -26.50];
L = [-11.80; -9.10; -11.00];


kRef = inv(-C*inv(A-B*K)*B);
F = mat2str([A-B*K, -B*K; zeros(length(A)), A-L*C])
G = mat2str([B*kRef; zeros(length(B*kRef), 1)])
H = mat2str([C, zeros(1, length(C))])