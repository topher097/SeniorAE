clear, clc
%% Insert provided data here:
A = [0.60 0.40 -0.30 0.30; -0.80 -0.40 -0.70 -0.90; 0.50 -0.40 0.70 0.50; 0.80 0.20 0.40 0.10];
B = [0.90; 0.80; 0.70; -0.10];
C = [0.30 -0.80 0.60 -0.20];
K = [5.50 -11.60 20.60 2.30];
L = [563.70; -835.00; -1161.00; 611.50];

%% Calculations -- do not modify
kRef = kRef(A,B,C,K);

F = [A-B*K -B*K; zeros(size(A)) A-L*C];
G = [B*kRef; zeros(length(B*kRef), 1)];
H = [C zeros(1, length(C))];

F = mat2str(F)
G = mat2str(G)
H = mat2str(H)