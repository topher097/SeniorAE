%%
clear; clc;

a_e = pi*(0.05^2)
p_i = 10132.5
p_e = 101.325

Thrust = (-p_e+p_i)*a_e

%%
clear; clc;
syms M
g = 1.4
func = (1  + .2*M^2)^(-2.5)*M*pi*(.035^2) == .10363*(2.71688)*pi*(.05^2)
S = vpa(solve(func),6)
