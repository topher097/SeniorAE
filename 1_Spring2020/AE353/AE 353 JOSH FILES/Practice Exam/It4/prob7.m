clear, clc
%% Insert Data
A = [0.7 0.7 0.9 0.9; -0.4 0.3 -0.6 0.9; -0.6 -0.3 0.3 -0.6; 0.3 -0.4 0.2 0.9];
B = [0.8; -0.7; 0.6; 0.0];
C = [-0.3 -0.6 0.7 -0.4];
D = [0.0];
K = [61.1 72.2 23.2 145.8];
kInt = 3.8;
kRef = inv(-C*inv(A-B*K)*B);

%% 
G = [C 0];
E = mat2str([A-B*K, -B*kInt; G])
F1 = mat2str([B*kRef; -1])
F2 = mat2str([B; 0])
G = mat2str(G)
H1 = 0
H2 = 0