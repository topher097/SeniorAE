clear all, close all, clc
%% Insert provided data here:
A = [-0.04 0.92; 0.02 0.02];
B = [0.02; 0.99];
C = [0.98 0.05];
D = [0.00];
K = [5.47 1.48];

%% Useful Relations
kRef = -1/(C*inv(A-B*K)*B);
r = 1;
d0 = 0;
d1 = 1;
Am = A-B*K;
Bm0 = [B*kRef, B]*[r; d0];
Bm1 = [B*kRef, B]*[r; d1];
Cm = C;

%% No disturbance 
sys1 = ss(Am,Bm0,Cm,D);
step(sys1)
figure(1)
S1 = stepinfo(sys1) %Look at the appended struct to calculate numbers

%% Disturbance
figure(2)
sys2 = ss(Am,Bm1,Cm,D);
step(sys2)

S2 = stepinfo(sys2) %Look at the appended struct to calculate numbers
