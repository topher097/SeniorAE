clear ,clc
A = [-0.10 0.00; 0.60 -1.00];
B = [-0.60; -0.30];
C = [0.30 0.30];
D = [0.00];
pTime = 4.50;
pOver = 0.12;
%%
s = -log(pOver) / pTime;
o = pi/ pTime;

p = [-s+o*j, -s-o*j];
K = place(A,B,p)
kRef = inv(-C*inv(A-B*K)*B)