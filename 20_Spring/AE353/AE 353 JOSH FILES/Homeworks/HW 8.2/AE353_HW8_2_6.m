%% HW 8.2.6
clc;
clear all;
syms t m y theta real

% Define u(t)
w = 5;
u = cos(w * t);

% Define y(t)
y = m* cos(w*t + theta);

theta_o = double(subs(u, t, 0))
y_o = vpa(subs(y, [t, theta], [0, theta_o]), 5)
m_o = solve(y_o, m)



