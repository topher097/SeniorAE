clear, clc

A = [0.8 -0.4 -0.5; -0.3 0.8 -0.7; -0.4 0.5 -0.2];
B = [0.6; -0.5; 0.9];
C = [-0.8 -0.7 0.2];
D = [0.0];
K = [10.0 -5.2 -3.9];
kRef = inv(-C*inv(A-B*K)*B);

E = mat2str(A-B*K)
F1 = mat2str(B*kRef)
F2 = mat2str(B)
G = mat2str(C-D*K)
H1 = D*kRef
H2 = D