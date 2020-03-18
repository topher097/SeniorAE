clear,clc

A = [-0.7 0.9; -0.6 0.4];
B = [-0.6; 0.4];
C = [-0.1 -0.6];
D = [0.0];
K = [-2.4 7.9];
kRef = inv(-C*inv(A-B*K)*B);

E = mat2str(A-B*K)
F1 = mat2str(B*kRef)
F2 = mat2str(B)
G = mat2str(C-D*K)
H1 = D*kRef
H2 = D