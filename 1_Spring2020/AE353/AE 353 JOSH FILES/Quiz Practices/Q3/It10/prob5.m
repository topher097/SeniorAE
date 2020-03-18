clear, clc

syms zDD zD z v real
eqn = 3*zDD + 2*zD - 8*z - 8 == v;

zE = -6;

x = [z; zD];
xD = [zD; solve(eqn, zDD)];
y = [z];
u = [v];

A = subs(jacobian(xD, x), zE)
B = jacobian(xD, u)
C = jacobian(y, x)