clear, clc
%% Provided data:
A = [-0.70 -0.90 0.30; -0.90 -0.50 0.50; 0.10 -0.50 0.80];
B = [0.40; 0.60; 0.40];
C = [-0.20 -0.90 -0.50];
D = [0.00];
p = [-3.01 -4.89 -8.22];

%% Calculations
r = poly(p);
r = r(2:end);

a = poly(A);
a = a(2:length(a));
c = eye(length(a));
d = zeros(length(a) - 1, 1);

Accf = [-a; c];
Accf(length(Accf),:) = [];
Bccf = [1;d];

W = ctrb(A,B);
Wccf = ctrb(Accf, Bccf);
Kccf = [r-a];

Vi = Wccf*inv(W);
V = inv(Vi);

K = vpa((Kccf * Wccf * inv(W)), 5)