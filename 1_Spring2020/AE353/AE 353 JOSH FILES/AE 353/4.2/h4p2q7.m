r = poly(p);
r = r(2:end);
rstr = mat2str(r)

a = charpoly(A);
a = a(2:end);
astr = mat2str(a)

[m,n] = size(A);
accf = -a;
Accf = [accf;eye(m - 1,m)];
Bccf = eye(m,1);
AccfStr = mat2str(Accf)
BccfStr = mat2str(Bccf)

Kccf = r + accf
KccfStr = mat2str(Kccf)

F = Accf;
G = Bccf;
Wccf = ctrb(F,G);
W = ctrb(A,B);
Vinv = Wccf*inv(W);
V = inv(Vinv);
Vstr = mat2str(V)

K = Kccf*Vinv
Kstr = mat2str(K)
