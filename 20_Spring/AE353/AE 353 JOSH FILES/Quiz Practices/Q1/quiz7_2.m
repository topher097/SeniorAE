clear, clc

syms qDD qD q mu

eqn = qDD + 6*qD + 2*q == -4*mu;

xD = [qD; solve(eqn, qDD)];
x = [q; qD];
u = [mu];
y = [q];

A = vpa(jacobian(xD, x), 6)
B = vpa(jacobian(xD, u), 6)
C = jacobian(y, x)
D = jacobian(y, u)