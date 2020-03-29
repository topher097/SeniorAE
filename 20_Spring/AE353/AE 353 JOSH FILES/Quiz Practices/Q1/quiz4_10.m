clear,clc

A = [0.02 1.08; -0.05 -0.08];
B = [-0.01; 0.94];
C = [1.04 -0.09];
D = [0.00];
K = [3.30 3.87];
kRef = inv(-C*inv(A-B*K)*B);
Am = A-B*K;
Bm = B*kRef;
Cm = C;

sys = ss(Am, Bm, Cm, D);
figure(1)
step(sys)

stepinfo(sys)