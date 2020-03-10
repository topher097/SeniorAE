clear, clc

syms a aD aDD tau

eqn = aDD - 4*aD - 8*a == 4*tau;

xD = [aD ; solve(eqn, aDD)];
x = [a; aD];
y = [a];
u = [tau];

A = vpa(jacobian(xD , x), 3)
B = vpa(jacobian(xD , u), 3)
C = vpa(jacobian(y , x), 3)
D = jacobian(y , u)