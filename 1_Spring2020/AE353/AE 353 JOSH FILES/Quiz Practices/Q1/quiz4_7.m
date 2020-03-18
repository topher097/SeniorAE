clear,clc

A = [0.0 0.8 -0.4; -0.3 0.2 -0.7; -0.4 0.9 0.9];
B = [-0.9; -0.2; 0.4];
C = [-0.5 0.0 0.3];
D = [0.0];
K = [6.9 13.7 42.7];
kRef = inv(-C*inv(A-B*K)*B);

E = mat2str(A-B*K)
F1 = mat2str(B*kRef)
F2 = mat2str(B)
G = mat2str(C-D*K)
H1 = D*kRef
H2 = D