clear,clc

syms wD w nD n t

eqn1 = wD - 3*w + 2*n == -3*t;
eqn2 = nD + 2*w - n == 3*t;

xD = [solve(eqn1, wD); solve(eqn2, nD)];

x = [w ; n];
u = [t];
y = [w];

A = jacobian(xD, x)
B = jacobian(xD, u)
C = jacobian(y, x)
D = jacobian(y, u)