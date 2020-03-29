Accf = [-a; 1 0]
Bccf = [1; 0]
Wccf = ctrb(Accf, Bccf)

Kccf = r-a

Vinv = Wccf * inv(W)
K = Kccf * Vinv