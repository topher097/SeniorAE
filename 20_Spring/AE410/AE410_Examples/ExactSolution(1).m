function [x,A,dA,rho,u,p,M] = ExactSolution(g,R,xs,Astar,Nx)

  % domain
  x = linspace(0,10,Nx).';
  
  % area
  [A,dA] = Area(x);
  
  % initialize
  rho = repmat(0,size(x));
  u   = repmat(0,size(x));
  p   = repmat(0,size(x));
  T   = repmat(0,size(x));
  M   = repmat(0,size(x));
  c   = repmat(0,size(x));
  
  % upstream conditions
  pt1 = 101325; %Pa
  Tt1 = 300;    %K
  
  % indices up and downstream of shock
  if (xs < 0) 
    iu = 1:Nx;
    id = [];
      
    % compute upstream supersonic flow ... need to find Mach number
    M(iu) = AreaMachRelation(x(iu),g,Astar,0.5);
    
  else
    iu = find(x < xs);
    id = find(x >= xs);
      
    % compute upstream supersonic flow ... need to find Mach number
    M(iu) = AreaMachRelation(x(iu),g,Astar,1.5);
  end
  
  % find shock conditions
  if (xs > 0)
    M1   = AreaMachRelation(xs,g,Astar,1.5);
    p1   = pt1 ./ (1 + (g-1)/2*M1^2)^(g/(g-1));
    T1   = Tt1 ./ (1 + (g-1)/2*M1^2);
    rho1 = p1 / (R * T1);
  end 
  
  % compute static values upstream of shock
  p(iu) = pt1 ./ (1 + (g-1)/2.*M(iu).^2) .^ (g/(g-1));
  T(iu) = Tt1 ./ (1 + (g-1)/2.*M(iu).^2);
  rho(iu) = p(iu) ./ (R * T(iu));
  c(iu) = sqrt(g * R * T(iu));
  u(iu) = M(iu) .* c(iu);
 
  if (xs > 0)
    % find post-shock conditions
    M2   = sqrt((M1^2+2/(g-1))/(2*g/(g-1)*M1^2-1));
    rho2 = (g+1)*M1^2/(2 + (g-1)*M1^2) * rho1;
    p2   = (1 + (2*g)/(g+1)*(M1^2-1))*p1;
    T2   = p2 / (R * rho2);
    pt2  = p2 * (1 + (g-1)/2*M2^2)^(g/(g-1));
    Tt2  = Tt1;
    Astar2 = Astar*(pt1/pt2);
  
    % compute downstream Mach number
    M(id) = AreaMachRelation(x(id),g,Astar2,0.5);
  
    % compute downstream quantitites
    p(id) = pt2 ./ (1 + (g-1)/2*M(id).^2).^(g/(g-1));
    T(id) = Tt2 ./ (1 + (g-1)/2*M(id).^2);
    rho(id) = p(id) ./ (R * T(id));
    c(id) = sqrt(g * R * T(id));
    u(id) = M(id) .* c(id);
  end
  
end


function [A,dA] = Area(x)

  a = 1.8;
  s = 5;

  A  = 1.398 + 0.347 * tanh(a*(x-s));
  dA = 0.347 * a * sech(a*(x-s)) .* sech(a*(x-s)); 
  
end
  

function M = AreaMachRelation(x,g,Astar,guess)

  % compute area
  A = Area(x);
  
  % output vector
  M = zeros(size(x));
  
  for i = 1:length(x)
      M(i) = fzero(@(y) (A(i)/Astar)^2 - (1./y).^2.*(2/(g+1)*(1+(g-1)/2.*y.^2)).^((g+1)/(g-1)),guess);
  end
  
end
  