function [ p, u ] = starpu( WL, WR, G )
%STARPU: compute the solution for pressure and velocity in the Star Region

  % expand input
  rhoL = WL(1); uL = WL(2); pL = WL(3); cL = WL(4);
  rhoR = WR(1); uR = WR(2); pR = WR(3); cR = WR(4);
  G1 = G(1); G3 = G(3); G4 = G(4); G5 = G(5); G6 = G(6); G7 = G(7);

  % initialize newton-rhapson
  pstart = guessp(WL,WR,G);
  pold   = pstart;
  udiff  = uR - uL;
  tolpre = 1e-6;
  nriter = 20;
  count  = 1;
  change  = 1;
  
  % compute pressure
  while (change > tolpre)
      [fL, fLD] = prefun(pold, rhoL, pL, cL, G);
      [fR, fRD] = prefun(pold, rhoR, pR, cR, G);
      p = pold - (fL + fR + udiff)/(fLD+fRD);
      change = 2*abs((p-pold)/(p+pold));
      if (p < 0)
          p = tolpre;
      end
      pold = p;
  end
  
  % compute velocity
  u = 0.5*(uL + uR + fR - fL);
  
end

