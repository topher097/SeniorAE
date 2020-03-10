clear, clc

%% Given values:
A = [-0.3 0.5; 0.1 0.0];
B = [0.2; 0.2];
p = [-6.0+4.0j -6.0-4.0j];

%% Finding the coefficients: r
r = poly(p);
r = r(2:end);

%% Finding the coefficients: a
a = poly(A);
a = a(2:end);
c = eye(length(a));
d = zeros(length(a)-1, 1);

%% Finding the A_ccf and B_ccf matrices:
Accf = [-a; c];
Accf(length(Accf),:) = [];
Bccf = [1; d];

%% Finding K_ccf:
W = ctrb(A, B);
Wccf = ctrb(Accf, Bccf);
Kccf = [r - a];

%% Finding invertible matrix, V:
Vi = Wccf*inv(W);
V = inv(Vi);

%% Finding K:
K = Kccf*Wccf*inv(W);

%% Answers:
r = mat2str(r)
a = mat2str(a)
Accf = mat2str(Accf)
Bccf = mat2str(Bccf)
Kccf = mat2str(Kccf)
V = mat2str(V)
K = mat2str(K)