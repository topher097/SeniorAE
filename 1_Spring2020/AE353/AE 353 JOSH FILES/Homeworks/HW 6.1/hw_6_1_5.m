clear, clc
%% Insert provided data here:
A = [-0.70 0.10; -0.90 0.30];
B = [0.20; 0.70];
C = [0.30 0.20];
p = [-3.65-3.95j -3.65+3.95j];

%% Calculations -- do not modify:
L = mat2str(acker(A', C', p)',5)