clear, clc

syms zDD zD z v real

eqn = 2*zDD - 2*zD - 3*z - 6 == v;

x = [z; zD];
xD = [zD; solve(eqn, zDD)];
u = [v];
y = [z];

A = jacobian(xD, x)
B = jacobian(xD, u)
C = jacobian(y, x)
D = jacobian(y, u)