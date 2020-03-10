clear, clc, syms p pD pDD f real
%% Insert pertinent information:
eqn = input('Equation: ');

%% Calculatons:

xD = [pD; solve(eqn, pDD)];
x = [p; pD];
u = [f];
y = [p];

A = jacobian(xD, x)
B = jacobian(xD, u)
C = jacobian(y, x)
D = jacobian(y, u)