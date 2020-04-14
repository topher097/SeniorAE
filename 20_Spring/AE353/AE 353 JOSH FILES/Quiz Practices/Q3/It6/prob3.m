clear, clc

A = [-0.8 -0.7 0.7; -0.8 0.8 -0.1; 0.7 -0.2 0.6];
B = [-0.7; 0.5; 0.1];
C = [-0.3 0.4 -0.6];
K1 = [-79.0 -59.0 -206.9];
K2 = [-307.1 -293.3 -803.3];
K3 = [76.4 130.3 35.0];
K4 = [90.8 130.5 146.0];
K5 = [-50.3 -58.0 -92.7];
L1 = [3857.5; 4234.2; 850.6];
L2 = [11.4; 29.6; 21.5];
L3 = [3565.8; 4099.8; 900.0];
L4 = [-3182.0; -1821.1; 412.3];
L5 = [-2824.9; -1852.0; 191.8];

F1 = eig([A-B*K1, -B*K1; zeros(size(A)), A-L1*C])
F2 = eig([A-B*K2, -B*K2; zeros(size(A)), A-L2*C])
F3 = eig([A-B*K3, -B*K3; zeros(size(A)), A-L3*C])
F4 = eig([A-B*K4, -B*K4; zeros(size(A)), A-L4*C])
F5 = eig([A-B*K5, -B*K5; zeros(size(A)), A-L5*C])