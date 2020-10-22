clear, clc
%% Insert provided data here:
A = [0.8 0.9; -0.9 0.6];
B = [0.5; 0.4];
C = [0.1 -0.1];
D = [0.0];
K = [9.4 1.4];
t0 = 0.8;
t1 = 1.2;
x0 = [-0.6; -0.7];
r = -0.5;
d = 0.3;

%% Calculation (do not edit)
kRef = -1/(C*inv(A-B*K)*B);
syms x y t

um = [r;d];
Am = A - B*K;
Bm = [B*kRef, B];
Cm = C;

x = mat2str(expm(Am*t1)*x0 + inv(Am)*expm(Am*t1)*Bm*um - inv(Am)*Bm*um)
y = mat2str(Cm*(expm(Am*t1)*x0 + inv(Am)*expm(Am*t1)*Bm*um - inv(Am)*Bm*um))