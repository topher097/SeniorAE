clear, clc
%% Provided data:
A = [-0.2 -0.5 -0.4 -0.7 -0.6; -0.3 0.6 0.6 0.4 -0.9; 0.1 0.9 -0.1 -0.9 0.6; -0.3 -0.9 -0.6 -0.1 -0.9; -0.4 1.0 -0.8 -0.8 -0.3];
B = [0.0; -0.4; 1.0; 0.4; -0.7];
p = [-10.0+3.0j -10.0-3.0j -9.0+0.0j -4.0+0.0j -8.0+0.0j];

%% Calculations:
r = poly(p);
r = r(:,2:end);

a = poly(A);
a = a(2:length(a));
c = eye(length(a));
d = zeros(length(a)-1, 1);

Accf = [-a; c];
Accf(length(Accf),:) = [];
Bccf = [1;d];

W = ctrb(A,B);
Wccf = ctrb(Accf, Bccf);
Kccf = [r - a];

Vi = Wccf*inv(W);
V = inv(Vi);

K = Kccf*Wccf*inv(W);

r = mat2str(r)
a = mat2str(a)
Accf = mat2str(Accf)
Bccf = mat2str(Bccf)
Kccf = mat2str(Kccf)
V = mat2str(V)
K = mat2str(K)
