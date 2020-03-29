clear,clc %WOKE
%% Insert provided data below:
A = [0.20 -0.90 0.70; 0.10 1.00 -0.10; -0.60 -0.10 0.60];
B = [0.70; 0.60; 0.10];
x0 = [-0.70; -1.00; -0.60];
xn = [0.80; -0.30; -0.70];
h = 0.80;

%% Calculations -- do not edit
F=expm(A*h);
G=inv(A)*(expm(A*h)-eye(length(A)))*B;
u = inv(ctrb(F,G))*(xn - F^(length(B))*x0)