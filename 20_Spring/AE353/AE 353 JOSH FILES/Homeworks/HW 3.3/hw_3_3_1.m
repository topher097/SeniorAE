clear,clc
%% Insert provided data here:


%% Calculation (do not edit)
kRef = kRef(A,B,C,K);
G = [C 0];
E = mat2str([A-B*K -B*kInt ; G])
F1 = mat2str([B*kRef ; -1])
F2 = mat2str([B ;0])
G = mat2str(G)
H1 = 0
H2 = 0