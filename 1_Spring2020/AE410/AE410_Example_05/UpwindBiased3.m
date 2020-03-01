function C = UpwindBiased3(Nx,dx,PeriodicFlag)
%
% [C] = Central2(Nx,dx,PeriodicFlag)
%
% Return the matrix for the 3rd order upwind scheme on a grid
% of Nx points with equal spacing dx.
%
% INPUTS:
%
% PeriodicFlag = 1 = TRUE;
% PeriodicFlag = 0 = FALSE;
%
% OUTPUTS:
%
% C     = B
%

fprintf(1,'Using 3rd-order upwind ');

V0 = ones([1,Nx]);
V1 = ones([1,Nx-1]);
V2 = ones([1,Nx-2]);
V3 = ones([1,Nx-3]);
V4 = ones([1,Nx-4]);

B = (diag(V2,-2)-6*diag(V1,-1)+3*diag(V0,0)+2*diag(V1,+1))/(6*dx);

if (PeriodicFlag == 0)
  fprintf(1,'bounded.\n');
  % boundary terms
  B(1,:)  = [-1 1 0*V2]/(dx);
  B(2,:)  = [-1 1 0*V2]/(dx);
  B(Nx,:) = [0*V2 -1 1]/(dx);
else
  fprintf(1,'periodic.\n');
  B(1,:)  = [3 2 0*V4 1 -6]/(6*dx);
  B(2,:)  = [-6 3 2 0*V4 1]/(6*dx);
  B(Nx,:) = [2 0*V4 1 -6 3]/(6*dx);
end

C = B;

return;
