clear, clc

A = [-0.8 0.5 0.2; -0.7 0.1 0.6; 0.5 0.0 0.4];
B = [0.6; 0.5; -0.3];
C = [0.8 -0.3 0.3];
D = [0.0];
K = [-12.1 -17.0 -64.2];
kRef = inv(-C*inv(A-B*K)*B);


E = mat2str(A-B*K)
F1 = mat2str(B*kRef)
F2 = mat2str(B)
G = mat2str(C-D*K)
H1 = D*kRef
H2 = D