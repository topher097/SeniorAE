clear, clc
%% Insert Provided Data here:
A = [1.00 0.10; -0.30 -0.40];
B = [-1.00; -0.70];
C = [0.80 -0.70];
t0 = 0.50;
x0 = [-0.60; -0.42];

%% Calculations -- do not modify:
Am = [A zeros(length(A), 1); C 0];
Bm = [B; 0];

kss = lqr(Am, Bm, eye(length(Am)), eye(1));
K = kss(1:length(A));
kInt = kss(end);
kRef = -1/(C*inv(A-B*K)*B);

K = mat2str(K)
kInt = mat2str(kInt, 2)
kRef = mat2str(kRef)