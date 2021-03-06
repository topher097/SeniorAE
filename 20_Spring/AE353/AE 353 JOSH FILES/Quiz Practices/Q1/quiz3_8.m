clear,clc

A = [-0.6 -0.2 0.1 -0.2; -0.5 -0.3 -0.9 -0.5; -0.2 -0.9 -0.8 -0.2; 0.5 0.2 0.9 0.1];
B = [-0.8; 0.4; 0.1; 0.2];
C = [0.9 0.8 0.6 -0.9];
D = [0.0];
K = [-152.3 -185.5 -136.9 -160.5];

kRef = inv(-C*inv(A-B*K)*B);

E = mat2str(A-B*K)
F1 = mat2str(B*kRef)
F2 = mat2str(B)
G = mat2str(C-D*K)
H1 = D*kRef
H2 = D