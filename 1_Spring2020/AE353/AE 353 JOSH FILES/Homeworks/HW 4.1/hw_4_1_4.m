clear, clc

%% Insert provided data here
A = [2.05503512 1.31557778 -7.95984658; -0.41808075 -1.75324598 8.31824348; 0.77703701 0.42462194 -5.30178914];
B = [-0.67481711; 1.10848855; -0.53698450];
C = [-1.37420025 -3.17266209 -4.82234738];
D = [0.00000000];
pTime = 4.90000000;
pOver = 0.27000000;

%% Calculations (Do not Edit)
omega = pi / pTime;
sigma = -log(pOver) / pTime;

p = [-sigma+omega*j -sigma-omega*j, -10*sigma];

K = acker(A,B,p);
kRef = kRef(A, B, C, K);

r = 0;
Am = A-B*K;
Bm = B*kRef;
Cm = C;
um = r;

sys = ss(Am, Bm, Cm, 0);
step(sys)

specs = stepinfo(sys);
pTime = specs.PeakTime
pOver = specs.Overshoot * 0.01