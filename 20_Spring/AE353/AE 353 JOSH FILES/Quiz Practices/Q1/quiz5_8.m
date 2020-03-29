clear,clc

A = [0 1; -9 -10];
B = [0; 1];
C = [1 0];
D = [0];
K = [0 -16];
x0 = [4; 10];
r = 3;
d = 1;

kRef = inv(-C*inv(A-B*K)*B);
Am = A-B*K;
Bm = [B*kRef B];
um = [r;d];
Cm = C;

syms t real

x = expm(Am*t)*x0 + inv(Am)*expm(Am*t)*Bm*um - inv(Am)*Bm*um;

y = Cm*x
