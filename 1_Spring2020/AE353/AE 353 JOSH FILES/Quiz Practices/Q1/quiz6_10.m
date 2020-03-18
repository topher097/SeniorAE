clear, clc

A = [0 1; 9 8];
B = [0; 1];
C = [1 0];
D = [0];
K = [85 23];
kInt = 130;
x0 = [-3; -1];
r = 4;
d = 4;

kRef = inv(-C*inv(A-B*K)*B);

G = [C, 0];
E = [A-B*K, -B*kInt; G];
F1 = [B*kRef; -1];
F2 = [B; 0];
H1= [D*kRef; -1];
H2 = [D; 0];

Am = E;
Bm = [F1, F2];
Cm = G;
um = [r; d];

I = eye(length(Am));
syms t real
z0 = [x0; 0];

z(t) = expm(Am*t)*z0 + inv(Am)*expm((Am) - I)*Bm*um;
y(t) = Cm*z