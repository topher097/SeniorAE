clear, clc
%% Insert provided data here:
A = [-0.50 -0.20 0.00; -0.80 0.90 0.90; 0.80 0.00 -0.90];
B = [-0.50; 0.00; -0.70];
C = [0.30 0.70 0.00];
K = [-1.00 -10.80 -2.70];
L = [935.60; -385.50; 1463.70];

%% Calculations -- do not modify
kRef = -1/(C*inv(A-B*K)*B);

F = [A-B*K -B*K; zeros(size(A)) A-L*C];
G = [B*kRef; zeros(length(B*kRef), 1)];
H = [C zeros(1, length(C))];

F = mat2str(F)
G = mat2str(G)
H = mat2str(H)