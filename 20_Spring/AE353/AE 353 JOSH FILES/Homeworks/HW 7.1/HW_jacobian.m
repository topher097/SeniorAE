clear, clc, syms z zD zDD v real
%% Insert pertinent information:
eqn = input('Equation: ');

%% Calculatons:

xD = [zD; solve(eqn, zDD)];
x = [z; zD];
u = [v];
y = [zD];

A = jacobian(xD, x)
B = jacobian(xD, u)
C = jacobian(y, x)
D = jacobian(y, u)