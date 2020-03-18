clear, clc
%% Insert provided data:
A = [-0.60 -0.90; -0.10 0.30];
C = [0.80 -0.60];
L = [0.50; -8.90];

%% Calculations -- do not modify:
eig = mat2str(eig(A-L*C).')