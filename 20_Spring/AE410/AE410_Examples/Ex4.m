% Ex4.m ... eigenvalues of various injection schemes

% clean up
clear all
% close all

% default plot attributes
set(0,'defaultaxesfontname','times');
set(0,'defaultaxesfontsize',20);
figID = 1;
Nx = 51;
L  = 1;
dx = L/Nx;
x  = dx*linspace(0,Nx-1,Nx).';
PeriodicFlag = 0;

% construct operator
D2c = Central2(Nx,dx,PeriodicFlag);
D3u = UpwindBiased3(Nx,dx,PeriodicFlag);
D4c = Pade346(Nx,dx,PeriodicFlag);

% Boundary matrix
B   = eye(Nx); B(1,1) = 0;

% eigenvalues
[V,eigD2c] = eig(-B*D2c);
[V,eigD3u] = eig(-B*D3u);
[V,eigD4c] = eig(-B*D4c);

% plot eigenvalues
figure(figID); figID = figID + 1; clf;
plot(real(eig(-D2c)),imag(eig(-D2c)),'bo');
%axis([-20 20 -100 100]);
title('2nd order central FD (w/o BC)');
xlabel('Real\{\lambda\}')
ylabel('Imag\{\lambda\}')
print('-dpng','eigD2cNOBC.png');
  
figure(figID); figID = figID + 1; clf;
plot(real(eig(-D3u)),imag(eig(-D3u)),'bo');
%axis([-20 20 -100 100]);
title('3rd order upwind FD (w/o BC)');
xlabel('Real\{\lambda\}')
ylabel('Imag\{\lambda\}')
print('-dpng','eigD3uNOBC.png');

figure(figID); figID = figID + 1; clf;
plot(real(eig(-D4c)),imag(eig(-D4c)),'bo');
%axis([-20 20 -100 100]);
title('3-4-6 order compact FD (w/o BC)');
xlabel('Real\{\lambda\}')
ylabel('Imag\{\lambda\}')
print('-dpng','eigD346cNOBC.png');

% plot eigenvalues
figure(figID); figID = figID + 1; clf;
plot(real(eigD2c),imag(eigD2c),'bo');
%axis([-20 20 -100 100]);
title('2nd order central FD (w/ BC)');
xlabel('Real\{\lambda\}')
ylabel('Imag\{\lambda\}')
print('-dpng','eigD2c.png');
  
figure(figID); figID = figID + 1; clf;
plot(real(eigD3u),imag(eigD3u),'bo');
%axis([-20 20 -100 100]);
title('3rd order upwind FD (w/ BC)');
xlabel('Real\{\lambda\}')
ylabel('Imag\{\lambda\}')
print('-dpng','eigD3u.png');

figure(figID); figID = figID + 1; clf;
plot(real(eigD4c),imag(eigD4c),'bo');
%axis([-20 20 -100 100]);
title('3-4-6 order compact FD (w/ BC)');
xlabel('Real\{\lambda\}')
ylabel('Imag\{\lambda\}')
print('-dpng','eigD346c.png');