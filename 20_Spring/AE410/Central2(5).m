function [C1,C2] = Central2UpDown(Nx,dx,PeriodicFlag)
%
% [C] = Central2(Nx,dx,PeriodicFlag)
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

fprintf(1,'Using 2nd-order central ');

V0 = ones([1,Nx  ]);
V1 = ones([1,Nx-1]);
V2 = ones([1,Nx-2]);
V3 = ones([1,Nx-3]);

B = (-diag(V1,-1)+diag(V1,1))/(2*dx);

if (PeriodicFlag == 0)
  % boundary terms
  fprintf(1,'bounded.\n');
  B(1,:) = [-1 1 0*V2]/dx;
  B(Nx,:) = [0*V2 -1 1]/dx;
else
  fprintf(1,'periodic.\n');
  B(1,:) = [0 1 0*V3 -1]/(2*dx);
  B(Nx,:) = [1 0*V3 -1 0]/(2*dx);
end

C1 = B;

B = (diag(V1,-1)-2*diag(V0,0)+diag(V1,1))/(dx*dx);

if (PeriodicFlag == 0)
  % boundary terms
  B(1,:) = [1 -2 1 0*V3]/(dx*dx);
  B(Nx,:) = [0*V3 1 -2 1]/(dx*dx);
else
  B(1,:) = [-2 1 0*V3 1]/(dx*dx);
  B(Nx,:) = [1 0*V3 1 -2]/(dx*dx);
end

C2 = B;

return;
