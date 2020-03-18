clear, clc
%% Insert provided data below:
A = [0.40 -0.80; -0.30 0.80];
B = [1.00; 0.00];
C = [0.00 1.00];
D = [0.00];
pTime = 2.70;
pOver = 0.14;

%% Calculations (do not modify)
%Finding Pee
omega = pi / pTime;
sigma = -log(pOver) / pTime;
p = [-sigma+omega*j -sigma-omega*j];


%% Finding K kRef
K = K_matrix(A,B,p)
kRef = kRef(A,B,C,K)