clear, clc
% 3.2.4

A = [0 1; 9 4];
B = [0; 1];
C = [1 0];
D = [0];
K = [13 0];
x0 = [-7; -4];
r = -3;
d = -3;

kRef = inv(-C*inv(A-B*K)*B);
um = [r;d];
Am = A - B*K;
Bm = [B*kRef, B];
Cm = C;
syms t
%%
y(t) = Cm*(expm(Am*t)*x0 + inv(Am)*expm(Am*t)*Bm*um - inv(Am)*Bm*um)