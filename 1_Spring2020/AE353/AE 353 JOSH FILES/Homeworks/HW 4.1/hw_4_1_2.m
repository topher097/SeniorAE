clear, clc
%% Insert provided data here
A = [-5.00 -7.00; -2.00 1.00];
B = [1.00; 0.00];
C = [0.00 1.00];
D = [0.00];
pTime = 2.30;
pOver = 0.34;

%% Calculations (do not edit)
omega = pi / pTime;
sigma = -log(pOver) / pTime;

p = vpa([-sigma + omega * j, -sigma - omega * j], 6)