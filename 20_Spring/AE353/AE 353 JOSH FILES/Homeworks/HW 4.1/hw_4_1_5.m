clear
%% Insert provided data below:
A = [-0.60 0.60; 0.90 0.50];
B = [-0.10; -0.80];
C = [-0.30 -0.90];
D = [0.00];
pTime = input('pTime = ');
pOver = input('pOver = ');

%% Calculations (do not modify)
%Finding Pee
omega = pi / pTime;
sigma = -log(pOver) / pTime;
p = [-sigma+omega*j -sigma-omega*j];

%% Bisection Method:
K = K_matrix(A,B,p);

kNew = K;
kRef = kRef(A,B,C,kNew);
Am = A-B*kNew;
Bm = B*kRef;
Cm = C;
um = 0;
specs = stepinfo(ss(Am, Bm, Cm, D));
pTimeNew = specs.PeakTime
pOverNew = specs.Overshoot * 0.01

K = mat2str(kNew);
kRef = mat2str(kRef);