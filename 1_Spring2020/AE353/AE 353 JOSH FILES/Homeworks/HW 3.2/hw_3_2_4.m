clear, clc
%% Insert provided data here:

%% Calculation (do not edit)
kRef = kRef(A,B,C,K);
um = [r;d];
Am = A - B*K;
Bm = [B*kRef, B];
Cm = C;
syms t
%%
y(t) = Cm*(expm(Am*t)*x0 + inv(Am)*expm(Am*t)*Bm*um - inv(Am)*Bm*um)