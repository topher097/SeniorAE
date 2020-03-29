clear, clc

A = [0.6 -0.9 0.6; -0.8 0.4 -0.9; 0.5 0.1 -0.5];
B = [0.7; -0.6; 0.9];
C = [0.6 -0.8 0.3];
D = [0.0];
K = [-2.7 -16.4 -4.1];
kInt = 1.3;

kRef = inv(-C*inv(A-B*K)*B);

G = [C 0];
E = mat2str([A-B*K, -B*kInt ; G])
F1 = mat2str([B*kRef ; -1])
F2 = mat2str([B; 0])
G = mat2str(G)
H1 = 0;
H2 = 0;