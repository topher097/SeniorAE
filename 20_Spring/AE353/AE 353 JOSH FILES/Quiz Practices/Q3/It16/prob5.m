clear, clc

A = [-0.3 -0.9; 0.4 -0.9];
B = [0.5; -0.3];
C = [-0.9 -0.1];
K1 = [127.5 182.5];
K2 = [8.0 8.0];
K3 = [118.1 138.8];
K4 = [52.4 47.3];
K5 = [18.4 3.3];
L1 = [-7.0; 7.0];
L2 = [-19.0; 37.4];
L3 = [-12.2; 24.0];
L4 = [0.0; 198.4];
L5 = [-15.3; 29.7];

F1 = eig([A-B*K1, -B*K1; zeros(length(A)), A-L1*C])
F2 = eig([A-B*K2, -B*K2; zeros(length(A)), A-L2*C])
F3 = eig([A-B*K3, -B*K3; zeros(length(A)), A-L3*C])
F4 = eig([A-B*K4, -B*K4; zeros(length(A)), A-L4*C])
F5 = eig([A-B*K5, -B*K5; zeros(length(A)), A-L5*C])