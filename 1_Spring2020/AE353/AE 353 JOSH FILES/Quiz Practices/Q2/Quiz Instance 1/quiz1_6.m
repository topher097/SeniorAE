clear, clc %WRONG
%% Provided data:
A = [-0.50 0.40 -0.20; 0.10 0.90 -0.30; -0.30 1.00 -0.50];
B = [0.50; 0.00; 0.00];
C = [0.00 0.50 0.00];
D = [0.00];
pTime = 2.80;
pOver = 0.11;

%% Calculations:
sigma = -log(pOver) / pTime;
omega = pi / pTime;

p = [-sigma+omega*j, -sigma-omega*j, -sigma+omega*j];

K = acker(A,B,p)
kRef = inv(-C*inv(A-B*K)*B)