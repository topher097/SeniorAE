function qdot = EulerODEChar(t,q,Dp,Dm)
% Inputs:
% Dp = upwind spacial derivative
% Dm = downwind spacial derivative
% properties
g = 1.4;

% size of domain
Nx = size(Dp,1);

% extract [rho, u, p]
rho = q(1:Nx);
u   = q((Nx+1):(2*Nx));
p   = q((2*Nx+1):(3*Nx));

% compute upwind and downwind derivatives
drhodxp = Dp * rho;
drhodxm = Dm * rho;
dudxp   = Dp * u;
dudxm   = Dm * u;
dpdxp   = Dp * p;
dpdxm   = Dm * p;

% space for time derivatives
drhodt = zeros(size(rho));
dudt   = zeros(size(u));
dpdt   = zeros(size(p));

% compute local dw/dt
for m = 1:Nx
    c2 = g * p(m) / rho(m);
    c  = sqrt(c2);
    M2 = u(m)*u(m)/c2;
    X = [1          1/c2                1/c2; ...
         0      -1/(rho(m)*c)       1/(rho(m)*c); ...
         0           1                   1];
    Lambda = diag([u(m),u(m)-c,u(m)+c]);
    Xinv = inv(X);
    Lambdap = 0.5*(Lambda + abs(Lambda));
    Lambdam = Lambda - Lambdap;
    
    dwdxp = Xinv * [drhodxp(m); dudxp(m); dpdxp(m)];
    dwdxm = Xinv * [drhodxm(m); dudxm(m); dpdxm(m)];
        
    dwdt  = - Lambdap * dwdxp - Lambdam * dwdxm;
    dqdt  = X * dwdt;
    
    drhodt(m) = dqdt(1);
    dudt(m)   = dqdt(2);
    dpdt(m)   = dqdt(3);
end

% work on left boundary (constant total Temperature & pressure)
c2 = g * p(1) / rho(1);
M2 = u(1)*u(1)/c2;
X = [1          1/c2                1/c2; ...
     0 -1/(rho(1)*sqrt(c2)) 1/(rho(1)*sqrt(c2)); ...
     0           1                   1];
Xinv = inv(X);
dwdt = Xinv * [drhodt(1); dudt(1); dpdt(1)];
if (abs(u(1)) > 1e-10)
  ap   = (1/p(1) - 1/(rho(1)*c2) + (g-1)*M2/(rho(1)*sqrt(c2)*u(1)));
  am   = (1/p(1) - 1/(rho(1)*c2) - (g-1)*M2/(rho(1)*sqrt(c2)*u(1)));
  bp   = (1-M2/2)/p(1) + g*M2/(2*rho(1)*c2) + g*M2/(rho(1)*sqrt(c2)*u(1));
  bm   = (1-M2/2)/p(1) + g*M2/(2*rho(1)*c2) - g*M2/(rho(1)*sqrt(c2)*u(1));
else
  ap   = (1/p(1) - 1/(rho(1)*c2));
  am   = (1/p(1) - 1/(rho(1)*c2));    
  bp   = (1-M2/2)/p(1) + g*M2/(2*rho(1)*c2);
  bm   = (1-M2/2)/p(1) + g*M2/(2*rho(1)*c2);
end
b1   = -(2*rho(1)*(bm*ap-bp*am))/(g*M2*ap+2*bp);
b2   = -(g*M2*am+2*bm)/(g*M2*ap+2*bp);
dwdt(1) = b1*dwdt(2);
dwdt(3) = b2*dwdt(2);
dqdt = X * dwdt;
drhodt(1) = dqdt(1);
dudt(1)   = dqdt(2);
dpdt(1)   = dqdt(3);

% work on right boundary (constant static pressure)
c2 = g * p(Nx) / rho(Nx);
M2 = u(Nx)*u(Nx)/c2;
X = [1           1/c2                 1/c2; ...
     0 -1/(rho(Nx)*sqrt(c2)) 1/(rho(Nx)*sqrt(c2)); ...
     0            1                    1];
Xinv = inv(X);
dwdt = Xinv * [drhodt(Nx); dudt(Nx); dpdt(Nx)];
p1 = 101325;
p2 = 0.8*p1;
a  = 2.5e-2;
s  = 1e-3;
dp = (p2-p1)/2/s*(sech((t-a)/s))^2;
dwdt(2) = -dwdt(3)+dp;
dqdt = X * dwdt;
drhodt(Nx) = dqdt(1);
dudt(Nx)   = dqdt(2);
dpdt(Nx)   = dqdt(3);

qdot = [drhodt; dudt; dpdt];
