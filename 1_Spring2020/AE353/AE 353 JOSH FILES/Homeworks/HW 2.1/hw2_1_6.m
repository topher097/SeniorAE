clear,clc
%% Insert provided data here:

%% Calculation (do not edit)
syms t
xt = expm((A-B*K)*t) * x0;
u = -K*xt;
y = C*xt + D*u