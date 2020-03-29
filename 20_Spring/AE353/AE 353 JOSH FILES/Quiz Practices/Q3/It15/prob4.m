clear, clc

syms zDD zD z v real

eqn = 10*zDD + 9*zD + 10*z + 9*z^3 == v;

zE = 2;

x = [z ; zD];
xD = [zD; solve(eqn, zDD)];
u = [v];
y = [zD];

A = subs(jacobian(xD, x), zE)
B = jacobian(xD, u)
C = jacobian(y, x)