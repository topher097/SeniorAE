clear, clc
%% Insert provided data here:


%% Calculation (do not edit)
Eig1 = eig([A-B*K1, -B*kInt1; C, 0])
Eig2 = eig([A-B*K2, -B*kInt2; C, 0])
Eig3 = eig([A-B*K3, -B*kInt3; C, 0])
Eig4 = eig([A-B*K4, -B*kInt4; C, 0])
Eig5 = eig([A-B*K5, -B*kInt5; C, 0])