clear, clc

syms tDD tD t u

eqn = 36*tDD + tD + 120*cos(t) == u;

tE = 0.4;

x = [tD ; t];
xD = [solve(eqn, tDD); tD];
u = [u];
y = [tD];

A = mat2str(double(subs(jacobian(xD, x), tE)))
B = mat2str(double(subs(jacobian(xD, u), tE)))
C = mat2str(double(jacobian(y, x)))
D = jacobian(y, u)