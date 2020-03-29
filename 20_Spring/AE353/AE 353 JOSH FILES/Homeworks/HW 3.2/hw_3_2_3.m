clear, clc
%% Insert provided data here:

%% Calculation (do not edit)
kRef = kRef(A,B,C,K);
syms x y t

um = [r;d];
Am = A - B*K;
Bm = [B*kRef, B];
Cm = C;

x = mat2str(expm(Am*t1)*x0 + inv(Am)*expm(Am*t1)*Bm*um - inv(Am)*Bm*um)
y = mat2str(Cm*(expm(Am*t1)*x0 + inv(Am)*expm(Am*t1)*Bm*um - inv(Am)*Bm*um))