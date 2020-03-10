clear, clc

syms tDD tD t b

tE = 1;

eqn = 3*tDD + 3*tD + 3*t + 7*t^3 == b;

xD = [tD; solve(eqn, tDD)];

x = [t; tD];
u = [b];
y = [t];

A = vpa(subs(jacobian(xD, x), tE), 6)
B = vpa(subs(jacobian(xD, u), tE), 6)
C = vpa(jacobian(y, x), 6)
D = vpa(jacobian(y, u), 6)