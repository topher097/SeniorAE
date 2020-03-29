% Ex1.m ... 2nd order Central finite difference example on periodic
% advection

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
PeriodicFlag = 1;
figure(figID); clf; figID = figID + 1;
plot(x,0*x,'bo');
line([0 1],[0 0]);
axis([-0.1 1.1 -1 1]);
xlabel('x');
print('-dpng','domain.png');

% construct operator
D1 = Central2(Nx,dx,PeriodicFlag);
figure(figID); clf; figID = figID + 1;
spy(D1)
print('-dpng','Sparsity.png');

% plot the eigenvalues of D
[V,D] = eig(D1);
figure(figID); clf; figID = figID + 1;
plot(real(diag(D)),imag(diag(D)),'bo');
axis([-1 1 -60 60]);
xlabel('Real\{\lambda\}')
ylabel('Imag\{\lambda\}')
print('-dpng','EigenvalueSpectrum.png');

% compute analytical eigenvalues/eigenvectors
b = D1(1,:);
nn = 0:Nx-1;
for n = 1:Nx
    lambda(n) = sum(b.*exp(i*2*pi*nn*(n-1)/Nx));
end
[J,N]=meshgrid(0:Nx-1,0:Nx-1);
X = exp(i*J.*(2*pi*N./Nx));
figure(figID); clf; figID = figID + 1;
for n = 1:2
    for m = 1:2
      jj = (n-1)*2 + m;
      subplot(2,2,jj);
      plot(x,real(X(:,jj)),'b-o',x,imag(X(:,jj)),'k-s');
      title(sprintf('\\lambda = %4.2f + %4.2f i',real(lambda(jj)),imag(lambda(jj))));
    end
end
print('-dpng','EigenvectorSpectrum.png');

figure(figID); clf; figID = figID + 1;
jj = floor((Nx+1)/4+1);
plot(x,real(X(:,jj)),'b-o',x,imag(X(:,jj)),'k-s');
title(sprintf('\\lambda = %4.2f + %4.2f i',real(lambda(jj)),imag(lambda(jj))));
print('-dpng','Nyquist.png');

% solve ODE using first non-constant eigenvector as IC
u0 = real(X(:,2));
[t,u] = ode45(@(t,y) advODE(t,y,D1),linspace(0,1,100),u0);
figure(figID); clf; figID = figID + 1;
for n = 1:length(t)
    [xx,ii] = sort(mod(x+t(n),1));
    plot(x,u(n,:),'b-o',xx,u0(ii),'k-')
    axis([-0.1 1.1 -1.1 1.1]);
    pause(0.1)
    if (n == 1)
        xlabel('x');
        ylabel('u');
    end
end

[t,u] = ode45(@(t,y) advODE(t,y,D1),linspace(0,100,11),u0);
figure(figID); clf; figID = figID + 1;
for n = 1:length(t)
    plot(x,u(n,:));
    hold on
end
xlabel('x');
ylabel('u');
title('Solution at t = 0, 10, ..., 100');
print('-dpng','SolutionTime0to100a.png');

% solve ODE using first non-constant eigenvector as IC
u0 = exp(-(x-0.5).^2/0.1^2);
[t,u] = ode45(@(t,y) advODE(t,y,D1),linspace(0,1,100),u0);
figure(figID); clf; figID = figID + 1;
for n = 1:length(t)
    [xx,ii] = sort(mod(x+t(n),1));
    plot(x,u(n,:),'b-o',xx,u0(ii),'k-')
    axis([-0.1 1.1 -0.1 1.1]);
    pause(0.1)
    if (n == 1)
        xlabel('x');
        ylabel('u');
    end
end
xlabel('x');
ylabel('u');
print('-dpng','SolutionOfPulse.png');

figure(figID); clf; figID = figID + 1;
jj = 1:(Nx+1)/2;
kdx = 2*pi*(jj-1)/Nx;
plot(kdx,dx*imag(lambda(1:(Nx+1)/2)),'b-o',kdx,kdx,'k-')
xlabel('k_m dx');
ylabel('k_m dx, Imag\{\lambda_m\} dx')
axis([0 pi 0 pi]);
title('Modified Wavenumber')
print('-dpng','ModifiedWavenumber.png');

% jj = floor((Nx+1)/4+1);
% u0 = real(X(:,jj));
% [t,u] = ode45(@(t,y) advODE(t,y,D1),linspace(0,1,100),u0);
% figure(figID); clf; figID = figID + 1;
% for n = 1:length(t)
%     [xx,ii] = sort(mod(x+t(n),1));
%     plot(x,u(n,:),'b-o',xx,u0(ii),'k-')
%     axis([-0.1 1.1 -1.1 1.1]);
%     pause(0.1)
%     if (n == 1)
%         xlabel('x');
%         ylabel('u');
% %     end
% % end
% xlabel('x');
% ylabel('u');

