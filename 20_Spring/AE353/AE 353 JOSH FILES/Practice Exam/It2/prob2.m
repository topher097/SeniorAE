clear, clc

syms nDD nD n t real
eqn = nDD - 7*nD == -6*t;

x = [n ; nD]; xD = [nD; solve(eqn, nDD)];
y = [n]; u = [t];

A = jacobian(xD, x)
B = jacobian(xD, u)
C = jacobian(y, x)
D = jacobian(y, u)