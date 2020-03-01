function C = Pade346(Nx,dx,PeriodicFlag)
%
% [C,kmax,kstar] = Pade346(Nx,dx,PeriodicFlag)
%
% Return the inv(A)*B matrix for the 3-4-6 Pade scheme on a grid
% of Nx points with equal spacing dx.
%
% INPUTS:
%
% PeriodicFlag = 1 = TRUE;
% PeriodicFlag = 0 = FALSE;
%
% OUTPUTS:
%
% C     = inv(A)*B
% kmax  = maximum wavenumber
% kstar = maximum wavenumber for a given accuracy
%


V0 = ones([1,Nx]);
V1 = ones([1,Nx-1]);
V2 = ones([1,Nx-2]);
V3 = ones([1,Nx-3]);
V4 = ones([1,Nx-4]);
V5 = ones([1,Nx-5]);
A = diag(V1,-1) + diag(3*V0,0) + diag(V1,+1);
B = (diag(-1/12*V2,-2) + diag(-7/3*V1,-1) + diag(7/3*V1,+1) + diag(1/12*V2,+2))/dx;
    
if (PeriodicFlag == 0)
  % boundary terms
  alpha  = 2;
  a      = -(11.0 + 2.0*alpha)/6.0;
  b      = (6.0 - alpha)/2.0;
  c      = (2.0*alpha - 3.0)/2.0;
  d      = (2.0 - alpha)/6.0;
  A(1,:) = [1 alpha 0*V2];
  B(1,:) = [a b c d 0*V4]/dx;
  A(2,:) = [1 4 1 0*V3];
  B(2,:) = [-3 0 3 0*V3]/dx;
  A(end-1,:) = [0*V3 1 4 1];
  B(end-1,:) = [0*V3 -3 0 3]/dx;
  A(end,:) = [0*V2 alpha 1];
  B(end,:) = [0*V4 -d -c -b -a]/dx;
else
  % periodic
  A(1,:) = [3 1 0*V3 1];
  B(1,:) = [0 7/3 1/12 0*V5 -1/12 -7/3]/dx;
  A(2,:) = [1 3 1 0*V3];
  B(2,:) = [-7/3 0 7/3 1/12 0*V5 -1/12]/dx;
  A(end-1,:) = [0*V3 1 3 1];
  A(end,:) = [1 0*V3 1 3];
  B(end-1,:) = [1/12 0*V5 -1/12 -7/3 0 7/3]/dx;
  B(end,:)   = [7/3 1/12 0*V5 -1/12 -7/3 0]/dx;
end

C = inv(A)*B;

return;
