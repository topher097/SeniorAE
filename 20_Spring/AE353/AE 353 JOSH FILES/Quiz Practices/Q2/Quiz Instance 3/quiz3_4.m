clear, clc
A = [-0.3 0.2 0.2; 0.3 0.7 0.5; -1.0 -0.4 0.0];
B = [-1.0; 0.7; -0.4];
p = [-7.0+0.0j -7.0+1.0j -7.0-1.0j];
r = poly(p);
r = r(2:end);
a = poly(A);
a = a(2:end);
c = eye(length(a));
d = zeros(length(a)- 1, 1);
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