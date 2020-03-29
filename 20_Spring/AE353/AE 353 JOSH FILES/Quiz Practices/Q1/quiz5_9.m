clear, clc

A = [-0.03 1.01; 0.04 -0.09];
B = [0.04; 1.10];
C = [0.94 0.08];
D = [0.00];
K = [1.25 2.05];
kRef = inv(-C*inv(A-B*K)*B);
Am = A-B*K;
Bm = B*kRef;
Cm = C;

sys = ss(Am, Bm, Cm, D);
step(sys)
stepinfo(sys)