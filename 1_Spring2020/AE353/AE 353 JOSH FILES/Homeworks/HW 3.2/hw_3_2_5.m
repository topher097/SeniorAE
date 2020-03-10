clear all, close all, clc
%% Insert provided data here:


%% Useful Relations
kRef = kRef(A,B,C,K);
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
