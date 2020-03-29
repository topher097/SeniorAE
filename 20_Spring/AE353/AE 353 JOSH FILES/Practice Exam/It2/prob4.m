clear, clc

A = [-0.1 0.3; 0.5 -0.9];
B = [0.6; 0.2];
C = [-0.8 0.5];
D = [0.0];
K = [2.8 -1.8];
kInt = 7.1;

kRef = inv(-C*inv(A-B*K)*B);

G = [C 0];
E = mat2str([A-B*K -B*kInt; G])
F1 = mat2str([B*kRef; -1])
F2 = mat2str([B; 0])
G = mat2str(G)