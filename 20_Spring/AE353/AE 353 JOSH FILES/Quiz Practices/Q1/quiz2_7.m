clear, clc

A = [0.0 -0.7; 0.3 0.6];
B = [-0.8; 0.2];
C = [0.4 -0.8];
D = [0.0];
K = [-4.0 -6.4];

kRef = inv(-C*inv(A-B*K)*B);

E = mat2str(A-B*K)
F1 = mat2str(B*kRef)
F2 = mat2str(B)
G = mat2str(C - D*K)
H1 = 0
H2 = 0