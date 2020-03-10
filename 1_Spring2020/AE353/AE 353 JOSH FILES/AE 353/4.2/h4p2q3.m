[m,n] = size(A)
a = charpoly(A)
a = a(2:end)
accf = -a
Accf = [accf;eye(m - 1,m)]
Bccf = eye(m,1)
mat2str(Accf)
mat2str(Bccf)