clear, clc

A = [0.60 0.70 -0.40; -0.60 0.70 0.70; 0.60 0.60 -0.20];
B = [0.30; -0.90; 0.70];
C = [-0.70 -0.10 -0.30];
K = [18.80 -29.80 -36.80];
L = [-2.20; -26.10; -8.80];

kRef = inv(-C*inv(A-B*K)*B);

F = mat2str([A, -B*K; L*C, A-B*K-L*C]);
G = mat2str([B*kRef; B*kRef]);
H = mat2str([C zeros(1,length(C))]);
