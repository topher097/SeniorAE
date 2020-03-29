clear, clc
%% Insert provided data here:
p = [2.0 -3.0];

%% Calculations: Trial 1
syms s real
% Use p(n) for length of p, then find coefficients (except for the first)
aCoef = (s - p(1))*(s - p(2))%*(s - p(3))*(s - p(4))*(s - p(5));
eqn = expand(aCoef)

%% Calculations: Trial 2
clear syms aCoef eqn
a = poly(p);
a = mat2str(a(2:end))