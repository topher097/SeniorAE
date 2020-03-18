clear, clc
% 3.2.5

A = [0.07 0.94; -0.02 0.08];
B = [-0.08; 1.02];
C = [0.97 0.01];
D = [0.00];
K = [2.36 3.19];

kRef = inv(-C*inv(A-B*K)*B);
r = 1;
d = 0;
Am = A-B*K;
Bm = [B*kRef, B]*[r; d];
Cm = C;

sys = ss(Am, Bm, Cm, D);
step(sys)
figure(1)
S = stepinfo(sys)