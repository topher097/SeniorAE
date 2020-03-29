clc;
clear all;
close all;

% default plot attributes
set(0,'defaultaxesfontname','times');
set(0,'defaultaxesfontsize',20);
figID = 1;
Nx = 25;
L  = 1;
dx = L/Nx;
x  = dx*linspace(0,Nx-1,Nx).';
PeriodicFlag = 1;

% construct operator
D1 = First(Nx,dx);
D2 = Second(Nx,dx);
D3 = Third(Nx,dx);

% plot the eigenvalues of D
D_list = {D1, D2, D3};
colors = ['b', 'r', 'g'];
symbols = ['o','x','.'];
figure(1);
hold on
for k = 1:length(D_list)
    D_i = D_list{k};
    c = colors(k);
    ss = symbols(k);
    
    % Compute eigenvalues/eigenvectors from D matrix and plot
    [V,D] = eig(D_i);
    D = diag(D);
    D = D(1:10);
    disp(D)
    s = strcat(c,ss);
    plot(real(diag(D)),imag(diag(D)),s);
end

axis([-1 1 -60 60]);
title('Eigenvalues')
xlabel('Re\{\lambda\}')
ylabel('Im\{\lambda\}')
legend('a', 'b', 'c');
hold off
print('-dpng','EigenvalueSpectrum.png');

figure(2);
hold on
for k = i:length(D_list)
    % Compute analytical eigenvalues/eigenvactors for D matrix and plot
    b = D_i(1,:);
    nn = 0:Nx-1;
    i = sqrt(-1);
    for n = 1:Nx
        lambda(n) = sum(b.*exp(i*2*pi*nn*(n-1)/Nx));
    end
    [J,N]=meshgrid(0:Nx-1,0:Nx-1);
    X = diag(exp(i*J.*(2*pi*N./Nx)));
    X = X(1:10);
    s = strcat(c,ss);
    plot(real(X),imag(X),s);
end

axis([-1 1 -60 60]);
title('Eigenvectors')
xlabel('Re\{\lambda\}')
ylabel('Im\{\lambda\}')
legend('a', 'b', 'c');
hold off

print('-dpng','EigenvectorSpectrum.png');

