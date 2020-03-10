clear, clc

A = [-0.09 0.92; -0.08 0.05];
B = [0.01; 0.96];
C = [0.97 0.03];
D = [0.00];
K = [6.21 2.32];

% syms t

kRef = inv(-C*inv(A-B*K)*B);
Am = A-B*K;
Bm = B*kRef;
Cm = C;
sys = ss(Am,Bm,Cm,D);
step(sys)
figure(1)
S1 = stepinfo(sys)