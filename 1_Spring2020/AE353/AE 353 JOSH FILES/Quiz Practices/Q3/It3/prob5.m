clear, clc

A = [-0.5 0.0; -0.7 -0.3];
B = [-0.8; -0.4];
C = [0.4 0.6];
K1 = [-26.3 70.1];
K2 = [-70.1 105.0];
K3 = [-78.1 118.6];
K4 = [-11.4 12.7];
K5 = [-32.5 46.4];
L1 = [-287.9; 166.6];
L2 = [-5.4; 19.4];
L3 = [1.9; 3.9];
L4 = [123.9; -89.9];
L5 = [-72.9; 57.9];

F1 = eig([A-B*K1, -B*K1; zeros(size(A)), A-L1*C])
F2 = eig([A-B*K2, -B*K2; zeros(size(A)), A-L2*C])
F3 = eig([A-B*K3, -B*K3; zeros(size(A)), A-L3*C])
F4 = eig([A-B*K4, -B*K4; zeros(size(A)), A-L4*C])
F5 = eig([A-B*K5, -B*K5; zeros(size(A)), A-L5*C])