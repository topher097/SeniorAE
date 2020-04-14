clear, clc

A = [-0.20 0.10 -0.20 0.70; 0.40 -0.60 -0.80 -0.20; -0.60 0.00 0.70 -0.20; 0.70 -0.80 0.90 -0.80];
B = [-0.20; 0.60; -0.70; -0.40];
C = [0.80 0.40 -0.60 0.80];
K = [-3.80 4.40 2.60 -3.70];
L = [33.10; -50.90; 118.50; 95.40];

kRef = inv(-C*inv(A-B*K)*B);

F = mat2str([A, -B*K; L*C, A-B*K-L*C])
G = mat2str([B*kRef; B*kRef])
H = mat2str([C, zeros(1, length(C))])