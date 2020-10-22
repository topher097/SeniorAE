clear,clc %WOKE
%% Insert provided data below:
A = [0.90 -0.10 0.80 0.90; 0.50 0.60 -0.80 -0.90; 0.20 0.60 0.20 -0.10; 0.90 0.30 0.40 0.90];
B = [-0.40; -1.00; -0.80; -0.90];
x0 = [-0.50; -0.60; 0.00; 0.50];
xn = [0.50; 0.20; 0.20; 0.90];
h = 0.70;

%% Calculations -- do not edit
F=expm(A*h);
G=inv(A)*(expm(A*h)-eye(length(A)))*B;
u = inv(ctrb(F,G))*(xn - F^(length(B))*x0);
disp(mat2str(u))