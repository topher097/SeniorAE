clear,clc

A = [0.4 0.4; -0.8 0.0];
B = [0.9; 0.9];
C = [0.3 0.4];
D = [0.0];
K = [4.3 -0.4];

kRef = inv(-C*inv(A-B*K)*B);

E = mat2str(A - B*K)
F1 = mat2str(B*kRef)
F2 = mat2str(B)
G = mat2str(C - D*K)