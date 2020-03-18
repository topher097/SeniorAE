clear,close all, clc
%% Insert provided data here:


%% Useful Relations
kRef = kRef(A,B,C,K);      %Make sure you have kRef() in your folder/path
G = [C, 0];
E = [A-B*K -B*kInt ; G];
F1 = [B*kRef ; -1];
F1a = [B*kRef+B ; -1];
F2 = [B ;0];
Am = E;
Bm = [F1 F2];
Bma = [F1a F2];
Cm = G;

%% No disturbance 
sys1 = ss(Am,Bm,Cm,D);
step(sys1)
figure(1)
S1 = stepinfo(sys1) %Look at the appended struct to calculate numbers


%% Disturbance
figure(2)
sys2 = ss(Am,Bma,Cm,D);
step(sys2)

S2 = stepinfo(sys2) %Look at the appended struct to calculate numbers
