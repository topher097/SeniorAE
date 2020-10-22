function [ qdot ] = EulerFV(t,q,g,x,A,dA)

  % initialize
  Nx   = length(x);
  dx   = x(2) - x(1);
  qdot = zeros([Nx 1]);
  f1   = zeros([Nx-1 1]);
  f2   = f1;
  f3   = f2;
  
  % split q into into components
  q1  = q(1:Nx);
  q2  = q((Nx+1):(2*Nx));
  q3  = q((2*Nx+1):(3*Nx));
  
  % compute primative vars
  u   = q2 ./ q1;
  p   = (g-1)*(q3 - 0.5 * q2 .* q2 ./ q1);
  
  % compute the fluxes
  ii = 1:Nx-1;
  tmp = q2;
  f1  = 0.5*(tmp(ii) + tmp(ii+1));
  tmp = q2 .* q2 ./ q1 + p;
  f2  = 0.5*(tmp(ii) + tmp(ii+1));
  tmp = (q3 + p) .* u;
  f3  = 0.5*(tmp(ii) + tmp(ii+1));
  
  % update the interior qdots
  jj = 2:Nx-1;
  jj1 = jj;
  jj2 = (Nx+2):(2*Nx-1);
  jj3 = (2*Nx+2):(3*Nx-1);
  qdot(jj1) = -(f1(jj) - f1(jj-1))/dx;
  qdot(jj2) = -(f2(jj) - f2(jj-1))/dx;
  qdot(jj3) = -(f3(jj) - f3(jj-1))/dx;
  
  % work on left boundary (constant total Temperature & pressure)
  % apply characteristics
  rho = q1(1);
  c2  = g * p(1) / rho;
  M2  = u(1)*u(1)/c2;
  X   = [1        1/c2             1/c2; ...
         0 -1/(rho*sqrt(c2)) 1/(rho*sqrt(c2)); ...
         0         1               1];
  Xinv = inv(X);
  % estimate the spatial derivatives
  dudx = (u(2)-u(1))/dx;
  dpdx = (p(2)-p(1))/dx;
  drdx = (q1(2)-q1(1))/dx;
%   dwdx = Xinv * [drdx; dudx; dpdx];
%   dwdx(1) = 0;
%   dwdx(3) = 0;
%   dqdx    = X * dwdx;
%   drdx    = dqdx(1);
%   dudx    = dqdx(2);
%   dpdx    = dqdx(3);
  % estimate the time derivatives
  drhodt = -u(1)*drdx-q1(1)*dudx-q1(1)/A(1)*dA(1);
  dudt   = -u(1)*dudx-dpdx/q1(1);
  dpdt   = -u(1)*dpdx-g*p(1)*dudx-q2(1)*g*p(1)/q1(1)/A(1)*dA(1);
  dwdt = Xinv * [drhodt; dudt; dpdt];
  if (abs(u(1)) > 1e-10)
    ap   = (1/p(1) - 1/(rho*c2) + (g-1)*M2/(rho*sqrt(c2)*u(1)));
    am   = (1/p(1) - 1/(rho*c2) - (g-1)*M2/(rho*sqrt(c2)*u(1)));
    bp   = (1-M2/2)/p(1) + g*M2/(2*rho*c2) + g*M2/(rho*sqrt(c2)*u(1));
    bm   = (1-M2/2)/p(1) + g*M2/(2*rho*c2) - g*M2/(rho*sqrt(c2)*u(1));
  else
    ap   = (1/p(1) - 1/(rho*c2));
    am   = (1/p(1) - 1/(rho*c2));    
    bp   = (1-M2/2)/p(1) + g*M2/(2*rho*c2);
    bm   = (1-M2/2)/p(1) + g*M2/(2*rho*c2);
  end
  b1   = -(2*rho*(bm*ap-bp*am))/(g*M2*ap+2*bp);
  b2   = -(g*M2*am+2*bm)/(g*M2*ap+2*bp);
  dwdt(1) = b1*dwdt(2);
  dwdt(3) = b2*dwdt(2);
  dqdt   = X * dwdt;
  drhodt = dqdt(1);
  dudt   = dqdt(2);
  dpdt   = dqdt(3);
  if (u(1) < sqrt(c2))
    qdot(1)      = drhodt;
    qdot(Nx+1)   = u(1)*drhodt + rho*dudt;
    qdot(2*Nx+1) = dpdt/(g-1) + 0.5*drhodt*u(1)*u(1)+rho*dudt*u(1);
  else
    qdot(1)      = 0;
    qdot(Nx+1)   = 0;
    qdot(2*Nx+1) = 0;
  end

  % work on right boundary (constant static pressure)
  % estimate the spatial derivatives
  dudx = (u(Nx)-u(Nx-1))/dx;
  dpdx = (p(Nx)-p(Nx-1))/dx;
  drdx = (q1(Nx)-q1(Nx-1))/dx;
  % estimate the time derivatives
  drhodt = -u(Nx)*drdx-q1(Nx)*dudx;
  dudt   = -u(Nx)*dudx-dpdx/q1(Nx);
  dpdt   = -u(Nx)*dpdx-g*p(Nx)*dudx;
  % apply characteristics
  rho = q1(Nx);
  c2 = g * p(Nx) / rho;
  M2 = u(Nx)*u(Nx)/c2;
  X = [1        1/c2             1/c2; ...
       0 -1/(rho*sqrt(c2)) 1/(rho*sqrt(c2)); ...
       0         1                1];
  Xinv = inv(X);
  dwdt = Xinv * [drhodt; dudt; dpdt];
  p1 = 101325;
  p2 = 0.8*p1;
  a  = 2.5e-2;
  s  = 1e-3;
  dp = 0.; %(p2-p1)/2/s*(sech((t-a)/s))^2;
  dwdt(2) = -dwdt(3)+dp;
  dqdt = X * dwdt;
  drhodt = dqdt(1);
  dudt   = dqdt(2);
  dpdt   = dqdt(3);
  qdot(Nx)   = drhodt;
  qdot(2*Nx) = u(Nx)*drhodt + rho*dudt;
  qdot(3*Nx) = dpdt/(g-1) + 0.5*drhodt*u(Nx)*u(Nx)+rho*dudt*u(Nx);
  
  % add the source terms
  jj1 = 1:Nx;
  jj2 = (Nx+1):(2*Nx);
  jj3 = (2*Nx+1):(3*Nx);
  qdot(jj1) = qdot(jj1) - 1./A .* dA .* q2;
  qdot(jj2) = qdot(jj2) - 1./A .* dA .* (q2 .* q2 ./ q1);
  qdot(jj3) = qdot(jj3) - 1./A .* dA .* (q3 + p) .* u;
  
end

