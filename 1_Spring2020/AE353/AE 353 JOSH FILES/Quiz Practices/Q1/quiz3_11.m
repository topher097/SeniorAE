clear, clc

A = [-0.03 0.91; -0.05 -0.01];
B = [0.06; 0.94];
C = [0.98 -0.09];
D = [0.00];
K = [54.11 2.11];
kRef = inv(-C*inv(A-B*K)*B);
Am = A-B*K;
Bm = B*kRef;
Cm = C;

sys = ss(Am,Bm,Cm,D);
step(sys)
System = stepinfo(sys)