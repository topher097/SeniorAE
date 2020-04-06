clear; clc;
syms t x d a b m c q r p u y pdot o odot w wdot xhat l
%Set up sub-functions
f(t,x,d) = a*x + b*u + d
g(t,x,d) = (q*(c*x - y)^2) + r*(d^2)
h(t,x) = m*(c*x - y)^2
dvdt = pdot*(x^2) + 2*odot*x + wdot
dvdx = 2*p*x + 2*o

%Set up HJB
left = -dvdt
right = -dvdx*f + g

%Find Minimum and Minimizer
func = 0==diff(right,d)
minimizer = solve(func,d)
d = minimizer
minimum = subs(right)

%substitute into HJB equation
HJB = 0==left + minimum
HJB = expand(HJB)
a1 = ( - 2*a*p*x^2 + c^2*q*x^2- (p^2*x^2)/r ) / (x^2);
A1 = expand(a1)
a2 = ( - 2*a*o*x  - 2*b*p*u*x - 2*c*q*x*y - (2*o*p*x)/r ) / (2*x);
A2 = expand(a2)
a3 = ( q*y^2 - o^2/r  - 2*b*o*u );
A3 = expand(a3)

% ODEs
pdot = A1
pto = m*(c^2)
odot = A2
oto = -m*c*y
wdot = A3
wto = m*(y^2)

%min xhat
func2 = 0==diff(p*x^2 + 2*o*x + w,x)
xhat = solve(func2,x)

%find l
xhatdot = -( ( odot*p - pdot*o ) / (p^2) )
func3 = xhatdot == a*xhat + b*u - l*(c*xhat - y)
L = solve(func3,l)

%find steady state error
%its literally pdot