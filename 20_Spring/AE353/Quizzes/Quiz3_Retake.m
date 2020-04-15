%% Quiz 3 retake
clc;
clear all;

%% p2
A1 = [33.3 -107.2 428.8; -8.7 28.2 -112.8; -4.8 15.5 -62.0];
A2 = [-0.1 0.0; 0.3 0.0];
A3 = [-6.3 -18.0 -93.8 -187.6; -11.1 -32.1 -165.8 -331.6; 10.0 26.7 140.0 280.0; -3.7 -9.6 -50.6 -101.2];
A4 = [9.9 36.4 -37.5 -150.0; -4.5 -15.4 15.5 62.0; -28.2 -105.5 109.7 438.8; 6.6 25.0 -26.1 -104.4];
A5 = [-11.8 -7.1 47.2; -2.6 -2.6 10.4; -3.6 -2.4 14.4];
C1 = [0.4 -1.3 5.2];
C2 = [0.1 0.0];
C3 = [0.4 1.1 5.7 11.4];
C4 = [-0.2 -0.9 1.0 4.0];
C5 = [0.4 0.4 -1.5];
% Choose whatever is a "large" number, anything basically zero is not it
Observable1 = det(obsv(A1, C1))
Observable2 = det(obsv(A2, C2))
Observable3 = det(obsv(A3, C3))
Observable4 = det(obsv(A4, C4))
Observable5 = det(obsv(A5, C5))

%% p4
A = [-0.20 0.60 0.30; -0.30 0.60 0.60; -0.70 -0.50 0.70];
B = [0.00; -0.10; -0.40];
C = [-0.50 -0.80 0.70];
p = [-8.05-1.42j -8.05+1.42j -8.03+0.00j];

L = mat2str(acker(A', C', p)',5)

%% p5
A = [0.6 -0.4; 0.7 -0.7];
B = [0.5; 0.9];
C = [0.6 -0.8];
L1 = [1729.5; 1277.1];
L2 = [2716.8; 2018.7];
L3 = [297.7; 215.4];
L4 = [1480.5; 1130.2];
L5 = [743.0; 572.0];

stab1 = eig(A-L1*C)
stab2 = eig(A-L2*C)
stab3 = eig(A-L3*C)
stab4 = eig(A-L4*C)
stab5 = eig(A-L5*C)

%% p6
A = [0.20 0.70; -0.70 0.00];
B = [-0.10; 0.70];
C = [-0.50 -0.80];
K = [-0.20 2.30];
L = [33.90; -24.00];

kRef = -1/(C*inv(A-B*K)*B);

[m, n] = size(C);

F = [A -B*K; L*C A-B*K-L*C];
G = [B*kRef; B*kRef];
H = [C zeros(1,n)];

F = mat2str(F)
G = mat2str(G)
H = mat2str(H)
