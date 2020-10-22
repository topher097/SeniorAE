clear, clc
%% Insert provided data here:
A = [0 1; -8 10];
B = [0; 1];
C = [1 0];
D = [0];
K = [1 16];
x0 = [5; -9];
r = -3;
d = -4;

%% Calculation (do not edit)
kRef = -1/(C*inv(A-B*K)*B);
um = [r;d];
Am = A - B*K;
Bm = [B*kRef, B];
Cm = C;
syms t
%%
y(t) = Cm*(expm(Am*t)*x0 + inv(Am)*expm(Am*t)*Bm*um - inv(Am)*Bm*um)