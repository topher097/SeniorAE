clear, clc

A = [0 1; 4 -2];
B = [0; 1];
C = [1 0];
D = [0];
K = [45 8];
kInt = 50;
x0 = [-9; 4];
r = -1;
d = 1;
kRef = inv(-C*inv(A-B*K)*B);
G = [C 0];
E = [(A-B*K), (-B*kInt); G];
F1 = [B*kRef; -1];
F2 = [B; 0];

Am = E;
Bm = [F1, F2];
Cm = G;
um = [r; d];
I = eye(length(Am));

syms t real
z0 = [x0; 0];
z = expm(Am*t)*z0 + inv(Am)*(expm(Am*t) - I)*Bm*um;

y = Cm*z