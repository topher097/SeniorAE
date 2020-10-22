clear, clc
%% Insert Provided Data below:
A = [10.00 -9.00 6.00; 21.00 -20.00 14.00; 16.00 -18.00 14.00];
B = [-1.00; -2.00; -2.00];
pdes = -2.00;
%% Calculations, please do not edit:
syms K1 K2 K3 K4 K5 K6 real
K = [K1 K2 K3];%; K4 K5 K6];

p = (vpa(eig(A-B*K),6));
%disp(p)

eqn = p(3) == pdes;
K2 = input('K2 = ');

a = solve(eqn, K1, K2)

disp(mat2str(vpa(subs(p, a(1), K2, a(3)))))
