clear, clc

A = [0.8 0.7 -0.8; 0.6 -0.7 -0.2; 0.7 0.2 0.4];
B = [-0.6; -0.5; 0.6];
C = [0.0 0.3 -0.4];
K1 = [-31.6 -400.8 -329.2];
K2 = [-73.7 477.1 339.9];
K3 = [-80.6 -346.9 -330.9];
K4 = [-22.2 -44.2 -41.7];
K5 = [-38.0 -312.5 -264.4];
L1 = [-1875.3; 6.5; -49.6];
L2 = [-6.9; -68.0; -37.8];
L3 = [-44.1; -14.6; -26.7];
L4 = [-215.9; -35.0; -58.2];
L5 = [-1682.4; -51.0; -97.3];

F1 = eig([A-B*K1, -B*K1; zeros(size(A)), A-L1*C])
F2 = eig([A-B*K2, -B*K2; zeros(size(A)), A-L2*C])
F3 = eig([A-B*K3, -B*K3; zeros(size(A)), A-L3*C])
F4 = eig([A-B*K4, -B*K4; zeros(size(A)), A-L4*C])
F5 = eig([A-B*K5, -B*K5; zeros(size(A)), A-L5*C])