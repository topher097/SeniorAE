clear all, close all, clc

nz = 3.1213;
W = 13500;
FS = 1.5;
lambda = 5.7/9.2;
b = 34;

L = nz*W*FS;


L_trap = @(y) (2*L/(b*(1+lambda)))*(1-2*y/b*(1-lambda));
L_ellip = @(y) (4*L/(pi*b))*sqrt(1-(2*y/b).^2);
L_sch = @(y) (((2*L/(b*(1+lambda)))*(1-2*y/b*(1-lambda)))+((4*L/(pi*b))*sqrt(1-(2*y/b).^2)))/2;

plot(linspace(0,b/2,1000)*12,L_trap(linspace(0,b/2,1000))/12), hold on
plot(linspace(0,b/2,1000)*12,L_ellip(linspace(0,b/2,1000))/12)
plot(linspace(0,b/2,1000)*12,L_sch(linspace(0,b/2,1000))/12)
xlabel( 'Spanwise Distance, $y$ (in)', 'interpreter', 'latex', 'fontsize', 12) 
ylabel( 'Lift, $L(y)$ (lbf/in)', 'interpreter', 'latex', 'fontsize', 12)
legend('Trapezoidal','Elliptical','Shrenk','location','best','interpreter','latex','fontsize',12)

%%
R = -integral(L_sch,0,b/2);
V = @(y) -R-integral(L_sch,0,y);

y = linspace(0,b/2,1000);
for i = 1:length(y)
    Vy(i) = V(y(i));
end
figure()
plot(y*12,-Vy)
xlabel( '$y$ [y]', 'interpreter', 'latex', 'fontsize', 12)
ylabel( '$V(y)$ [lbf]', 'interpreter', 'latex', 'fontsize', 12)


%%
M = integral(@(y)L_sch(y).*y,0,b/2);
M_y = @(y) M-integral(@(y)L_sch(y).*y,0,y)-V(y)*y;
for i = 1:length(y)
    My(i) = M_y(y(i));
end
figure()
plot(y*12,My*12)
xlabel( '\$y$ (in)', 'interpreter', 'latex', 'fontsize', 12)
ylabel( 'Bending Moment, $M(y)$ (lbf-ft)', 'interpreter', 'latex', 'fontsize', 12)
