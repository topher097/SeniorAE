%% Quiz 3
clc;
clear all;

%% Problem 1




%% Problem 2
A = [0.5 -0.9; -0.9 0.0];
B = [-0.7; -0.5];
C = [0.6 0.5];
K1 = [-10.5 20.5];
K2 = [-29.8 22.8];
K3 = [-6.2 4.6];
K4 = [-54.8 86.1];
K5 = [-22.5 25.7];
L1 = [75.5; -118.8];
L2 = [221.5; -252.0];
L3 = [24.0; -17.2];
L4 = [103.6; -133.0];
L5 = [117.6; -115.5];

stab1 = eig(A-L1*C)
stab2 = eig(A-L2*C)
stab3 = eig(A-L3*C)
stab4 = eig(A-L4*C)
stab5 = eig(A-L5*C)

%% Problem 3



%% Problem 4
A = [0.40 -0.40 -0.40; 0.50 0.70 0.50; 0.70 0.80 -0.40];
B = [-0.40; -0.70; -0.70];
C = [0.70 0.90 -0.60];
K = [3.00 -3.00 -5.50];
L = [341.80; -389.70; -208.80];

kRef = -1/(C*inv(A-B*K)*B);

[m, n] = size(C);

F = [A -B*K; L*C A-B*K-L*C];
G = [B*kRef; B*kRef];
H = [C zeros(1,n)];

F = mat2str(F)
G = mat2str(G)
H = mat2str(H)



%% Problem 5
A = [0.80 0.40 0.60 0.50; 0.10 -0.60 0.50 0.20; -0.80 -0.60 0.40 0.80; 0.70 0.60 0.30 0.70];
B = [-0.30; 0.10; -0.40; -0.90];
C = [-0.20 0.40 -0.50 -0.10];
p = [-2.68 -2.92 -2.00 -6.82];
L = mat2str(acker(A', C', p)',5)

%% Problem 6



%% Problem 7
A1 = [-1.7 -1.7; 2.2 2.2];
A2 = [-1.1 4.4; -0.3 1.2];
A3 = [-11.8 66.5 23.6; 0.0 0.0 0.0; -6.3 35.5 12.6];
A4 = [30.1 0.4 117.0 -234.0; 26.0 2.1 105.4 -210.8; -40.6 -5.2 -169.9 339.8; -16.2 -2.5 -68.9 137.8];
A5 = [-12.5 55.6 70.2 -70.2; -7.6 34.9 46.0 -46.0; -6.4 32.3 47.5 -47.5; -10.0 49.1 70.1 -70.1];
C1 = [-0.1 -0.1];
C2 = [0.1 -0.5];
C3 = [0.0 0.1 0.0];
C4 = [2.1 0.5 9.3 -18.6];
C5 = [0.7 -3.4 -4.8 4.8];
% Choose whatever is a small number, anything basically zero is not it
Observable1 = det(obsv(A1, C1))
Observable2 = det(obsv(A2, C2))
Observable3 = det(obsv(A3, C3))
Observable4 = det(obsv(A4, C4))
Observable5 = det(obsv(A5, C5))


%% Problem 8
A = [-0.70 -0.20 0.40 -1.00; 0.50 -0.10 0.50 -0.40; 0.40 0.70 0.20 -0.40; 0.60 1.00 0.50 0.80];
B = [0.20 -0.40 0.20; 0.30 -0.50 0.00; -0.30 -0.90 1.00; -0.70 -0.70 0.50];
C = [-0.50 -0.10 -0.20 -0.50];
Qo = [1.30];
Ro = [4.40 0.35 0.45 -0.90; 0.35 3.80 0.00 0.05; 0.45 0.00 3.90 -0.40; -0.90 0.05 -0.40 4.60];

L = mat2str(lqr(A', C', inv(Ro), inv(Qo))')

