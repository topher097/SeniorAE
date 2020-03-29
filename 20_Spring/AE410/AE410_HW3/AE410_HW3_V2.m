%% Prob 1
clear all;
close all; 
clc;

% default plot attributes
set(0,'defaultaxesfontname','times');
set(0,'defaultaxesfontsize',20);
figID = 1;

Nx = 51;
L  = 2*pi;
dx = L/Nx;
x  = dx*linspace(0,Nx-1,Nx).';

% Construct matrix operator
D1 = First(Nx,dx);      % Periodic domain
D2 = Second(Nx,dx);     % Periodic domain
D3 = Third(Nx,dx);
D1sparse = sparse(D1);
D2sparse = sparse(D2);
D3sparse = sparse(D3);

%% Prob 2
% Equation to differentiate
f = sin(x);

syms a
f1 =  sin(a);
derivative = diff(f1);
DR = subs(derivative,a,x);

f1 = D1sparse * f;
f2 = D2sparse * f;
f3 = D3sparse * f;

% plot 
figure(figID); figID = figID + 1; clf;
plot(x,f1,'linewidth',2)
hold on;
plot(x,f2,'linewidth',2)
plot(x,f3,'linewidth',2)
plot(x,DR,'ko')
h = legend( '1a','1b','1c','Analaytical' );
set(h, 'location', 'best', 'interpreter', 'latex', 'fontsize', 16)
xlabel( '$x$', 'interpreter', 'latex', 'fontsize', 16)
ylabel( '$\frac{df}{dx}$', 'interpreter', 'latex', 'fontsize', 14)
title('Numerical Approximation 1a-1c ')
print( '-dpng', 'picture2', '-r150' )
%%
figure(figID); figID = figID + 1; clf;
plot(x,abs(DR-f1),'linewidth',2)
hold on;
plot(x,abs(DR-f2),'linewidth',2)
plot(x,abs(DR-f3),'linewidth',2)
h = legend( '1a','1b','1c' );
set( h, 'location', 'best', 'interpreter', 'latex', 'fontsize', 16)
xlabel( '$x$', 'interpreter', 'latex', 'fontsize', 14)
ylabel( 'error', 'interpreter', 'latex', 'fontsize', 14)
set(gca, 'YScale', 'log')
title('Error Between Analytical and Numeric 1a-1c')
print( '-dpng', 'picture3', '-r150' )
%% compare to truncaiton 1a
truncation_error_term(1,:) = abs(((-dx^4)/30)*(cos(x)));
figure(figID); figID = figID + 1; clf;
plot(x,abs(DR-f1),'linewidth',3), hold on;
plot(x,truncation_error_term(1,:),'linewidth',2)
h = legend( '1a','ErrTrunc' );
set( h, 'location', 'best', 'interpreter', 'latex', 'fontsize', 16)
xlabel( '$x$', 'interpreter', 'latex', 'fontsize', 16)
ylabel( 'error', 'interpreter', 'latex', 'fontsize', 16)
title('Error Compared to Truncation 1a')
print( '-dpng', 'picture4', '-r150' )
%% compare to truncaiton 1b
truncation_error_term(2,:) = abs(((dx^3)/12)*(sin(x)));
figure(figID); figID = figID + 1; clf;
plot(x,abs(DR-f2),'linewidth',3), hold on;
plot(x,truncation_error_term(2,:),'linewidth',2)
h = legend( '1b','ErrTrunc' );
set( h, 'location', 'best', 'interpreter', 'latex', 'fontsize', 16)
xlabel( '$x$', 'interpreter', 'latex', 'fontsize', 16)
ylabel( 'error', 'interpreter', 'latex', 'fontsize', 16)
title('Error Compared to Truncation 1b')
print( '-dpng', 'picture5', '-r150' )
%% compare to truncaiton 1c
truncation_error_term(3,:) = abs(((4*dx^6)/factorial(7))*(-cos(x)));
figure(figID); figID = figID + 1; clf;
plot(x,abs(DR-f3),'linewidth',3), hold on;
plot(x,truncation_error_term(3,:),'linewidth',2)
h = legend( '1c','ErrTrunc' );
set( h, 'location', 'best', 'interpreter', 'latex', 'fontsize', 16)
xlabel( '$x$', 'interpreter', 'latex', 'fontsize', 16)
ylabel( 'error', 'interpreter', 'latex', 'fontsize', 16)
title('Error Compared to Truncation 1c')
print( '-dpng', 'picture6', '-r150' )
%%
% plot the eigenvalues of D (first 10 entries)
[V1,De1,W1] = eig(D1);
[V2,De2,W2] = eig(D2);
[V3,De3,W3] = eig(D3);
De1 = De1(:,1:10);
De2 = De2(:,1:10);
De3 = De3(:,1:10);

figure(figID); figID = figID + 1; clf;
plot(real(diag(De1)),imag(diag(De1)),'bo','markersize',4), hold on;
plot(real(diag(De2)),imag(diag(De2)),'ro','markersize',4)
plot(real(diag(De3)),imag(diag(De3)),'go','markersize',4)
h = legend( '1a','1b','1c' );
set( h, 'location', 'best', 'interpreter', 'latex', 'fontsize', 16)
xlabel( '$Real\{\lambda\}$', 'interpreter', 'latex', 'fontsize', 16)
ylabel( '$Imag\{\lambda\}$', 'interpreter', 'latex', 'fontsize', 16)
title('Eigenvals of Numeric Matrices')
print( '-dpng', 'picture7', '-r150' )

%%
function D = First(Nx,dx)
% Periodic domain, returns the D matrix for the derivative from 1a

a=zeros([5 1]);
a(1)=1/12;
a(2)=-2/3;
a(3)=0;
a(4)=2/3;
a(5)=-1/12;

r=[a(3) a(4) a(5) zeros([1 Nx-5]) a(1) a(2) ];
M = zeros(Nx,Nx);
for i=1:Nx
    M(i,:) = r;
    r = circshift(r,1);
end
M = M * (1/dx);
D = M;
return;
end
%%
function D = Second(Nx,dx)
% Periodic domain, calculated the D matrix for the derivative from 1b
a = zeros([4 1]);
a(1) = 1/6;
a(2) = -1;
a(3) = 1/2;
a(4) = 1/3;

r = [a(3) a(4) zeros([1 Nx-4]) a(1) a(2)];
M = zeros(Nx,Nx);
for i=1:Nx
    M(i,:) = r;
    r = circshift(r,1);
end
M = M * (1/dx);
D = M;
return;
end
%%
function D = Third(Nx,dx)
% Implicit FD, use the Pade scheme approximation

al = 1/3;

a = zeros([5 1]);
a(1) = -(4*al-1)/12;
a(2) = -(al+2)*4/12;
a(3) = 0;
a(4) = (al+2)*4/12;
a(5) = (4*al-1)/12;

r1 = [a(3) a(4) a(5) zeros([1 Nx-5]) a(1) a(2) ];
r2 = [1 al zeros([1 Nx-3]) al ];
A = zeros(Nx,Nx);
B = zeros(Nx,Nx);

for i=1:Nx
    B(i,:) = r1;
    r1 = circshift(r1,1);
    A(i,:) = r2;
    r2 = circshift(r2,1);
end
B = B * (1/dx);
M = inv(A)*B;
D = M;
return;
end
