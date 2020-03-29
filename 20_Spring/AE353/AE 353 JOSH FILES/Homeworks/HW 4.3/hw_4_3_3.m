clear, clc
%% Insert Provided Data below:
A = [3.00 4.00 2.00; 0.00 -1.00 0.00; -12.00 -12.00 -7.00];
B = [-1.00; 2.00; -2.00];
pdes = -1.00;

%% Calculations, please do not edit:
syms K1 K2 K3 K4 K5 K6 real
K = [K1 K2 K3];%; K4 K5 K6];

p = vpa(eig(A-B*K),6)

eqn = p(3) == pdes;
% K2 = input('K2 = ');
