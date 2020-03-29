%% LQR Derivation
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
HJB = collect(HJB,x)



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

%% Find L given A,B,C,p
clear; clc;
A = [-0.10 0.60 0.20; 0.80 -0.60 -0.80; 0.70 -0.60 -0.40];
B = [-0.30; 0.20; -0.20];
C = [0.20 0.90 -0.50];
p = [-6.38-4.73j -6.38+4.73j -3.18+0.00j];

L = acker(A',C',p)'
disp(mat2str(L))

%% Identify Observable Systems
clear; clc;
A1 = [5.3 10.1 -10.6; -0.5 -1.1 1.0; 1.9 3.2 -3.8];
A2 = [-3.5 7.0; -1.6 3.2];
A3 = [-0.9 -2.2 0.0; 0.2 0.5 0.0; 0.0 -0.2 0.0];
A4 = [-0.5 -0.5; 0.3 0.3];
A5 = [0.4 1.9 -7.0 -7.0; -10.3 -33.0 122.4 122.4; 2.4 7.7 -28.6 -28.6; -5.1 -16.3 60.5 60.5];
C1 = [-0.2 -0.8 0.3];
C2 = [-0.4 0.9];
C3 = [0.0 -0.1 0.0];
C4 = [-0.1 -0.1];
C5 = [-0.5 -1.7 6.4 6.4];

d1 = det(obsv(A1,C1))
d2 = det(obsv(A2,C2))
d3 = det(obsv(A3,C3))
d4 = det(obsv(A4,C4))
d5 = det(obsv(A5,C5))

%% Graph with Q/R ratios
%Order the ratios, and see how xhat follows the lines, several versions

%% Design a controller
%Linearize, then set variables as needed
%remember eulers method

%% Find F,G,H
clear; clc;
A = [0.30 0.10; -0.10 0.20];
B = [0.40; -0.40];
C = [-0.80 -0.70];
K = [-8.50 -11.70];
L = [111.50; -136.30];

[m,n] = size(C);
kref=-inv(C*inv(A-B*K)*B);

F=[A -B*K;L*C A-B*K-L*C];
G=[B*kref;B*kref];
H=[C zeros(1,n)];
disp(mat2str(F))
disp(mat2str(G))
disp(mat2str(H))

%% Find L given A,B,C,Q,R
clear; clc;
A = [-0.30 0.30 -0.60; 0.40 -0.10 1.00; 0.60 1.00 0.50];
B = [-0.60; -0.80; -0.90];
C = [-1.00 0.40 -0.60; 0.00 -1.00 -0.30];
Ro = [2.60 -0.25; -0.25 2.50];
Qo = [2.10 -0.65 0.35; -0.65 2.60 0.10; 0.35 0.10 2.10];

L = lqr(A',C',inv(Qo),inv(Ro))'

%% Identify Asymptotically stable systems
clear; clc;
A = [0.4 -0.8 -0.7 0.2; 0.2 -0.5 0.4 0.5; -0.6 0.8 0.2 0.8; -0.6 -0.5 0.5 0.4];
B = [0.0; 0.5; -0.9; 0.0];
C = [-0.7 -0.9 0.7 -0.6];
K1 = [35056.0 11151.0 6163.6 3063.6];
K2 = [3269.4 2058.5 1139.3 -246.2];
K3 = [5063.1 574.0 301.5 1020.9];
K4 = [10163.2 844.9 435.6 2167.3];
K5 = [2605.0 -363.3 -223.4 812.5];
L1 = [-46.1; 44.0; 94.3; 72.2];
L2 = [4709.9; 815.5; 2412.0; -3877.5];
L3 = [-1805.9; 85.4; 661.3; 2701.1];
L4 = [-161.8; 54.5; 195.0; 317.0];
L5 = [-911.5; 83.8; 460.0; 1436.9];

eig([A -B*K1;L1*C A-B*K1-L1*C])
eig([A -B*K2;L2*C A-B*K2-L2*C])
eig([A -B*K3;L3*C A-B*K3-L3*C])
eig([A -B*K4;L4*C A-B*K4-L4*C])
eig([A -B*K5;L5*C A-B*K5-L5*C])