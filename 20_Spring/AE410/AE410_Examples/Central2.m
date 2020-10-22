function C = Central2(Nx,dx,PeriodicFlag)
%
% [C] = Central2(Nx,dx,PeriodicFlag)
%
% Return the matrix for the 1-2-1 Central second order FD scheme on a grid
% of Nx points with equal spacing dx.
%
% INPUTS:
%
% PeriodicFlag = 1 = TRUE;
% PeriodicFlag = 0 = FALSE;
%
% OUTPUTS:
% C = inv(A)*B

fprintf(1,'Using 2nd-order central ');

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

C = B;

return;
