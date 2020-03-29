clear, clc

syms zDD zD z v real

eqn = 8*zDD - 2*zD - 2*z + 6 == v;

x = [z; zD];
xD = [zD; solve(eqn, zDD)];
u = [v];
y = [z];

zE = -2;

A = subs(jacobian(xD, x), zE)
B = jacobian(xD, u)
C = jacobian(y, x)