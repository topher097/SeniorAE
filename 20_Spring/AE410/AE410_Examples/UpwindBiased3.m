function C = UpwindBiased3(Nx,dx,PeriodicFlag)
%
% [C] = Central2(Nx,dx,PeriodicFlag)
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

fprintf(1,'Using 3rd-order upwind ');

V0 = ones([1,Nx]);
V1 = ones([1,Nx-1]);
V2 = ones([1,Nx-2]);
V3 = ones([1,Nx-3]);
V4 = ones([1,Nx-4]);

B = (diag(V2,-2)-6*diag(V1,-1)+3*diag(V0,0)+2*diag(V1,+1))/(6*dx);

if (PeriodicFlag == 0)
  % boundary terms
  error('No boundary stencil implemented.')
else
  fprintf(1,'periodic.\n');
  B(1,:)  = [3 2 0*V4 1 -6]/(6*dx);
  B(2,:)  = [-6 3 2 0*V4 1]/(6*dx);
  B(Nx,:) = [2 0*V4 1 -6 3]/(6*dx);
end

C = B;

return;
