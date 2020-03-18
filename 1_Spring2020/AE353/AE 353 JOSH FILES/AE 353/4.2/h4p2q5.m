[m,n] = size(A)
a = charpoly(A)
a = a(2:end)
accf = -a
Accf = [accf;eye(m - 1,m)]
Bccf = eye(m,1)
W = ctrb(A,B)
Wccf = ctrb(Accf,Bccf)
Kccf = r + Accf(1,1:end)
K = Kccf*Wccf*inv(W)
mat2str(K)