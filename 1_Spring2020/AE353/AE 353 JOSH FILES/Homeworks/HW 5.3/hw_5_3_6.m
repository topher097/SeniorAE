clear, clc
%% Insert Provided Data here:
A = [-0.10 0.40 -0.80; -0.90 -0.40 0.00; -0.50 -0.50 -0.40];
B = [0.50; 0.00; -0.90];
C = [0.10 -1.00 -0.10];
t0 = 0.30;
x0 = [-0.18; -0.13; 0.93];

%% Calculations -- do not modify:
Am = [A zeros(length(A), 1); C 0];
Bm = [B; 0];

kss = lqr(Am, Bm, eye(length(Am)), eye(1));
K = kss(1:length(A));
kInt = kss(end);
kRef = kRef(A,B,C,K);

K = mat2str(K)
kInt = mat2str(kInt, 2)
kRef = mat2str(kRef)