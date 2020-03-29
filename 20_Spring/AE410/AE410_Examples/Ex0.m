% Ex0.m ... Programming 2nd order Central finite difference example

% clean up
clear all
% close all

% default plot attributes
set(0,'defaultaxesfontname','times');
set(0,'defaultaxesfontsize',20);
figID = 1;
Nx = 5001;
L  = 1;
dx = L/Nx;
x  = dx*linspace(0,Nx-1,Nx).';
PeriodicFlag = 0;
NTIMES = 1000;

% construct matrix operator
D1 = Central2(Nx,dx,PeriodicFlag);
D1sparse = sparse(D1);

% vector to be differentiated
f = x.^2;

% differentiate
tic;
for n = 1:NTIMES
  f1 = D1 * f;
end
f1time = toc/NTIMES;

tic;
for n = 1:NTIMES
    f2 = D1sparse * f;
end
f2time = toc/NTIMES;

tic; 
for n = 1:NTIMES
  f3 = zeros(size(x));
  f3(1) = (f(2)-f(1))/dx;
  for j = 2:Nx-1
      f3(j) = (f(j+1)-f(j-1))/(2*dx);
  end
  f3(Nx) = (f(Nx)-f(Nx-1))/dx;
end
f3time = toc/NTIMES;

% plot
figure(figID); figID = figID + 1; clf;
plot(x,f1,x,f2,x,f3)
xlabel('x');
ylabel('df/dx')

fprintf(1,'  Full Matrix Time: %f seconds.\n', f1time);
fprintf(1,'Sparse Matrix Time: %f seconds.\n', f2time);
fprintf(1,'         Loop Time: %f seconds.\n', f3time);