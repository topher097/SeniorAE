clear,clc

A = [0.0 1.0; 4.0 -9.0];
B = [0.0; 1.0];
C = [1.0 0.0];
D = [0.0];
K = [13.0 -15.0];
x0 = [4.0; 4.0];
r = 3.0;
d = -1.0;
kRef = inv(-C*inv(A-B*K)*B);

Am = A-B*K;
Bm = [B*kRef B];
um = [r; d];
Cm = C;
syms t real
x = expm(Am*t)*x0 + inv(Am)*expm(Am*t)*Bm*um - inv(Am)*Bm*um;
y = C*x