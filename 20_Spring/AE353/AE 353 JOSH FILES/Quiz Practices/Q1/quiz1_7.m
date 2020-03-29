clear, clc

A = [0.0 1.0; 0.0 7.0];
B = [0.0; 1.0];
C = [1.0 0.0];
D = [0.0];
K = [-4.0 4.0];
x0 = [-1.0; -1.0];
r = -2.0;
d = 3.0;

kRef = inv(-C*inv(A-B*K)*B);

syms t

Am = A - B*K;
Bm = [B*kRef B];
um = [r; d];
Cm = C;

x = expm(Am*t)*x0 + inv(Am)*expm(Am*t)*Bm*um - inv(Am)*Bm*um;

y = Cm*x