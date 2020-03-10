clear, clc

syms pDD pD p b real

eqn = pDD - 3*pD + 8*p == -6*b;

x = [p; pD];
xD = [pD; solve(eqn, pDD)];
u = [b];
y = [pD];

A = jacobian(xD, x)
B = jacobian(xD, u)
C = jacobian(y, x)
D = jacobian(y, u)