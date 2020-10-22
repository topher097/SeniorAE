clear, clc
%% Insert provided data here:
A = [0.9 0.7 0.9; 0.5 -0.3 0.1; -0.2 0.7 -0.2];
B = [0.2; -0.7; 0.0];
C = [0.2 0.7 0.6];
D = [0.0];
K = [-12.7 -8.2 -7.2];

%% Calculation (do not edit)

kRef = -1/(C*inv(A-B*K)*B);
F = (C)*(-inv(A - B*K))*B