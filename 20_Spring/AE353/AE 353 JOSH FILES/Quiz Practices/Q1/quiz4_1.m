clear,clc

syms zDD zD z b

eqn = zDD + 6*zD - 5*z == 9*b;

xD = [zD, solve(eqn, zDD)];

x = [z ; zD];
y = [zD];
u = [b];

A = vpa(jacobian(xD, x), 6)
B = vpa(jacobian(xD, u), 6)
C = jacobian(y, x)
D = jacobian(y, u)