clear, clc

A = [-0.04 0.93; -0.04 0.00];
B = [0.05; 1.09];
C = [1.00 0.09];
D = [0.00];
K = [57.19 5.29];

kRef = inv(-C*inv(A-B*K)*B);

Am = A-B*K;
Bm = B*kRef;
Cm = C;

sys = ss(Am, Bm, Cm, D);
step(sys)
stepinfo(sys)
