function [ out ] = guessp( WL, WR, G )
%GUESSP: provide a guess value for pressure PM in Star Region

  % expand input
  rhoL = WL(1); uL = WL(2); pL = WL(3); cL = WL(4);
  rhoR = WR(1); uR = WR(2); pR = WR(3); cR = WR(4);
  G1 = G(1); G3 = G(3); G4 = G(4); G5 = G(5); G6 = G(6); G7 = G(7);

  quser = 2;
  cup   = 0.25*(rhoL + rhoR)*(cL + cR);
  ppv   = max(0.5*(pL + pR) + 0.5*(uL - uR)*cup,0);
  pmin  = min(pL,pR);
  pmax  = max(pL,pR);
  qmax  = pmax/pmin;
  
  if (qmax <= quser & (pmin <= ppv & ppv <= pmax))
      pm = ppv;
  else
      if (ppv < pmin)
          pq = (pL/pR)^G1;
          um = (pq*uL/cL + uR/cR + G4*(pq-1))/(pq/cL+1/cR);
          ptL = 1.0 + G7*(uL-um)/cL;
          ptR = 1.0 + G7*(um-uR)/cR;
          pm  = 0.5*(pL*ptL^G3 + pR*ptR^G3);
      else
          gel = sqrt((G5/rhoL)/(G6*pL+ppv));
          ger = sqrt((G5/rhoR)/(G6*pR+ppv));
          pm  = (gel*pL + ger*pR - (uR-uL))/(gel+ger);
      end
  end
          
  out = pm;
    
end

