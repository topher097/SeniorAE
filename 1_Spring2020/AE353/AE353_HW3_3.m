%%
A = [-0.9 -0.3 -0.3 -0.8; -0.3 -0.9 0.6 0.1; -0.9 -0.9 0.9 0.2; 0.1 -0.1 0.1 0.4];
B = [0.5; -0.3; 0.4; 0.2];
C = [0.4 0.7 -0.9 -0.9];
D = [0.0];
K = [4.6 8.6 5.8 4.3];
kInt = 9.4;
kRef = -1/(C*inv(A-B*K)*B)

E = [A-B*K -B*kInt; C 0]
F = [B*kRef B; -1 0]
F1 = F(:,1)
F2 = F(:,2)

G = [C 0]

%%
A = [0.10 0.10 0.50; 0.90 -0.70 0.30; 0.60 0.40 0.10];
B = [-0.50; 0.80; 0.20];
C = [0.80 0.30 0.90];
D = [0.00];
K1 = [15.88 2.00 24.90];
kInt1 = [-175.71];
K2 = [-76.49 -27.09 -68.47];
kInt2 = [-71.00];
K3 = [-0.96 -2.48 23.61];
kInt3 = [-14.76];
K4 = [19.11 4.68 37.18];
kInt4 = [45.32];
K5 = [185.85 33.91 318.39];
kInt5 = [-424.76];


kRef1 = -1/(C*inv(A-B*K1)*B);
E1 = [A-B*K1 -B*kInt1; C 0];
eig(E1)

kRef2 = -1/(C*inv(A-B*K2)*B);
E2 = [A-B*K2 -B*kInt2; C 0];
eig(E2) 

kRef3 = -1/(C*inv(A-B*K3)*B);
E3 = [A-B*K3 -B*kInt3; C 0];
eig(E3)

kRef4 = -1/(C*inv(A-B*K4)*B);
E4 = [A-B*K4 -B*kInt4; C 0];
eig(E4)

kRef5 = -1/(C*inv(A-B*K5)*B);
E5 = [A-B*K5 -B*kInt5; C 0];
eig(E5)

%%
A = [0 1; -10 -3];
B = [0; 1];
C = [1 0];
D = [0];
K = [31 7];
kInt = 50;
x0 = [-9; 7];
r = -3;
d = -2;

syms t real
E = [A-(B*K) -B*kInt; C 0];
Einv = inv(E);
kref = 1/(-C*((A-(B*K))^-1)*B);

Bm = [B*kref B; -1 0];
um = [r; d];
G = [C 0];
x0m = [x0;0];
yt = G*(expm(E*(t))*x0m + Einv*expm(E*(t))*Bm*um - Einv*Bm*um)
%%
A = [-0.40 -0.90; 0.60 0.00];
B = [-0.10; 0.70];
C = [0.20 0.80];
D = [0.00];
K = [240.68 43.27];
kInt = 299.97;
t0 = 0.90;
t1 = 1.00;
x0 = [-0.40; -1.00];
r = 0.40;
d = -0.30;

syms t

E = [A-(B*K) -B*kInt; C 0];

Einv = inv(E); kref = 1/(-C*((A-(B*K))^-1)*B);

x0m = [x0;0]

Bm = [B*kref B; -1 0];
um = [r; d]; G = [C 0];

xt = expm(E*(t1-t0))*x0m + Einv*expm(E*(t1-t0))*Bm*um - Einv*Bm*um
yt = G*(expm(E*(t1-t0))*x0m + Einv*expm(E*(t1-t0))*Bm*um - Einv*Bm*um)

%%
clc;
clear;
A = [0.08 0.96; -0.02 0.03];
B = [0.06; 1.05];
C = [1.00 0.01];
D = [0.00];
K = [44.82 7.31];
kInt = 65.93;

kRef = -1/(C*(A-B*K)^-1*B);

G = [C, 0];
E = [A-B*K -B*kInt ; G];
F1 = [B*kRef ; -1];
F1a = [B*kRef+B ; -1];
F2 = [B ;0];
Am = E;
Bm = [F1 F2];
Bma = [F1a F2];
Cm = G;

% No disturbance
sys1 = ss(Am,Bm,Cm,D);
S1 = stepinfo(sys1, 'SettlingTimeThreshold', 0.05);
%S1a = S1(1,1)
s1_risetime = S1.RiseTime
s1_timetopeak = S1.PeakTime
s1_overshoot = S1.Overshoot
s1_settlingtime = S1.SettlingTime
s1_error = 0


% Disturbance
sys2 = ss(Am,Bma,Cm,D);
step(sys2)

S2 = stepinfo(sys2, 'SettlingTimeThreshold', 0.05);
%S2a = S2(1,1)
s2_risetime = S2.RiseTime
s2_timetopeak = S2.PeakTime
s2_overshoot = S2.Overshoot
s2_settlingtime = S2.SettlingTime
s2_error = 0
