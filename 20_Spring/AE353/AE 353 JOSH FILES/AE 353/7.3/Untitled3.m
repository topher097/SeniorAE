clear all ; clc
syms a x b u d c y m r p o w pdot odot wdot q
f = a*x+b*u+d;
g = q*(c*x-y)^2+r*(d^2);
h = m*(c*x-y)^2;
v = p*x^2 + 2*o*x + w;
dvdt = pdot*x^2+2*odot*x+wdot;
dvdx = 2*p*x+2*o;
% HJB equation
% part 1
HJB1 = -dvdt
HJB2 = -dvdx*f+g
% minimizer
minimizer = diff(HJB2,d)
% minimum
minimum = subs(HJB2,minimizer)
expand(minimum)
% Plug into HJB
a1 = -8*a*p^3+4*c^2*p^2*q
a2 = (4*d*p^2+4*a*o*p-16*a*o*p^2+8*a*p^2*r+4*b*p^2*u+4*c*p*q*y+8*c^2*o*p*q*-4*c^2*p*q*r)/2
a3 = d*r-2*d*o+4*a*o^2+q*y^2-2*a*p*r^2+4*c^2*o^2*q+c^2*q*r^2-2*a*o*r+4*d*o*p-2*b*o*u-2*d*p*r-8*a*o^2*p+8*a*o*p*r+4*b*o*p*u-2*b*p*r*u+4*c*o*q*y-2*c*q*r*y-4*c^2*o*q*r
% ODEs
pdot = -a1
pto = 1;
odot = -a2
oto = 1;
wdot = -a3
wto = 1;
% value function minimization
xhat = 1;
l = 1;
o = 1;