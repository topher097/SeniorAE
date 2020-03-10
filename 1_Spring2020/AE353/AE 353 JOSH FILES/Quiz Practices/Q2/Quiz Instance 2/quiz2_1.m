clear, clc
%% Insert provided values:
A = [-0.60 0.60 -0.80; 0.20 0.50 0.40; -0.60 -0.60 0.30];
B = [0.40; 0.20; 0.30];
C = [-0.80 -0.20 0.60];
D = [0.00];
p = [-2.42+0.00j -1.54-0.15j -1.54+0.15j];

%% Calculations:
K = mat2str(acker(A,B,p))