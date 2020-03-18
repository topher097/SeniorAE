clear, clc
%% Insert provided data here:

%% Calculations (do not edit)
xt = expm((A - B*K)*(t1-t0)) * x0
y = C*xt + D*(-K * xt)