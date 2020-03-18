clear, clc

A = [0.5 -0.9; 0.7 -0.2];
B = [-0.6; -0.2];
C = [0.3 -0.3];
K1 = [-4.4 9.7];
K2 = [23.2 -144.0];
K3 = [135.9 -315.1];
K4 = [-18.0 4.4];
K5 = [33.9 -175.1];
L1 = [88.0; 102.4];
L2 = [-631.0; -572.0];
L3 = [-151.8; -109.1];
L4 = [-394.4; -362.7];
L5 = [-81.4; -124.8];

F1 = eig([A-B*K1, -B*K1; zeros(length(A)), A-L1*C])
F2 = eig([A-B*K2, -B*K2; zeros(length(A)), A-L2*C])
F3 = eig([A-B*K3, -B*K3; zeros(length(A)), A-L3*C])
F4 = eig([A-B*K4, -B*K4; zeros(length(A)), A-L4*C])
F5 = eig([A-B*K5, -B*K5; zeros(length(A)), A-L5*C])
