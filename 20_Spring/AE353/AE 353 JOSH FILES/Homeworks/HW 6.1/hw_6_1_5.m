clear, clc
%% Insert provided data here:
A = [0.50 -0.40 0.20 -0.50; 0.40 0.10 0.40 -0.70; -0.70 -0.10 -0.40 0.90; 0.50 -0.10 0.90 -0.70];
B = [0.80; -0.30; 0.10; -0.60];
C = [0.40 -0.90 0.90 -0.40];
p = [-0.89-0.59j -0.89+0.59j -7.96+0.00j -1.96+0.00j];

%% Calculations -- do not modify:
L = mat2str(acker(A', C', p)',5)