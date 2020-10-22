function [ f, fd ] = prefun(p, dk, pk, ck, G)
%PREFUN: evaluate the pressure functions fL and fR in exact Riemann solver

  % expand input
  G1 = G(1); G2 = G(2); G4 = G(4); G5 = G(5); G6 = G(6);

  if (p <= pk)
      prat = p/pk;
      f    = G4*ck*(prat^G1-1);
      fd   = (1/(dk*ck))*prat^(-G2);
  else
      ak   = G5/dk;
      bk   = G6*pk;
      qrt  = sqrt(ak/(bk+p));
      f    = (p-pk)*qrt;
      fd   = (1.0 - 0.5*(p-pk)/(bk+p))*qrt;
  end

end