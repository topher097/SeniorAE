clear, clc

A = [0.00 1.02; 0.03 0.09];
B = [-0.02; 0.91];
C = [0.95 0.08];
D = [0.00];
K = [0.92 2.12];

kRef = inv(-C*inv(A-B*K)*B);

Am = A-B*K;
Bm = B*kRef;
Cm = C;

sys = ss(Am, Bm, Cm, D);
step(sys)
figure(1)
S1 = stepinfo(sys)