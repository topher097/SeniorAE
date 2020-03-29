%% Prob 1
clc;
clean all;

A = [-0.20 0.50 0.80; -0.30 0.10 0.60; 0.70 0.30 0.50];
B = [-0.40; 0.50; 0.20];
C = [-0.60 -0.50 0.90];
r = 3.20;
t0 = 0.40;
x0 = [-0.48; 0.68; -0.35];

Q = diag([25, 5, 25, 5]);
R = diag([10]);
[K, P] = lqr(A, B, Q, R);
disp(K); 
%% Prob 2
clc;
clean all;





%% Prob 3
clc;
clean all;






%% Prob 4
clc;
clean all;



