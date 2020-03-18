clear,clc

syms wDD wD w b

wE = -2;

eqn = 4*wDD + wD + 8*w + w^3 == b;

xD = [solve(eqn, wDD), wD];

x = [wD; w];
u = [b];
y = [wD];

A = vpa(subs(jacobian(xD,  x), wE), 6)
B = vpa(subs(jacobian(xD, u), wE), 6)
C = vpa(jacobian(y, x), 6)
D = vpa(jacobian(y, u), 6)