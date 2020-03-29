clc;
clear all;

A = [-0.60 -0.70; -0.20 -0.60];
B = [0.40; 0.40];
C = [-0.70 0.90];
D = [0.00];
p = [-8.69 -9.12];

r = poly(p);
r = r(2:end);

a = poly(A);
a = a(2:length(a));
c = eye(length(a));
d = zeros(length(a)-1,1);

Accf = [-a; c];
Accf(length(Accf),:) = [];
Bccf = [1;d];

W = ctrb(A, B);
Wccf = ctrb(Accf, Bccf);
Kccf = r-a;

V = W*inv(Wccf);
Vi = inv(V);

K = Kccf*Vi;
K = mat2str(K)

