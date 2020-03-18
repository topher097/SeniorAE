clear, clc

syms q qD qDD t
eqn = qDD - 3*qD + 2*q == 7*t;

x = [q; qD]; u = [t]; y = [qD]; xD = [qD; solve(eqn, qDD)];

A = jacobian(xD, x)
B = jacobian(xD, u)
C = jacobian(y, x)
D = jacobian(y, u)