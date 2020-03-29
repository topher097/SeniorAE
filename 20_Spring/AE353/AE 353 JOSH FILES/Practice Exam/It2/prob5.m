clear, clc

A = [0 1; -8 6];
B = [0; 1];
C = [1 0];
D = [0];
K = [8 11];
kInt = 30;
x0 = [9; -1];
r = -4;
d = 4;

kRef = inv(-C*inv(A-B*K)*B);

G = [C 0];
E = [A-B*K -B*kInt; G];
F1 = [B*kRef; -1];
F2 = [B; 0];

Am = E;
Bm = [F1 F2];
Cm = G;
um = [r; d];
I = eye(length(Am));

syms t real

z0 = [x0; 0];
z = expm(Am*t)*z0 + Am^-1*(expm(Am*t) - I)*Bm * um;
y = Cm*z
