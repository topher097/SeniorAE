clear,clc

A = [0.04 0.98; 0.08 -0.07];
B = [-0.06; 0.97];
C = [1.04 0.03];
D = [0.00];
K = [14.33 4.66];
kRef = inv(-C*inv(A-B*K)*B);
Am = A-B*K;
Bm = B*kRef;
Cm = C;


sys = ss(Am, Bm, Cm, D);
step(sys)