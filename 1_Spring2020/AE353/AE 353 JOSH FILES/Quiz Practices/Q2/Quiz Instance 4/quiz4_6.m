clear, clc
A = [0.80 -0.60; -0.50 -0.80];
B = [0.90; -0.40];
C = [-0.70 -0.80];
D = [0.00];
pTime = 4.00;
pOver = 0.11;

s = -log(pOver) / pTime;
o = pi / pTime;

p = [-s+o*j, -s-o*j];
K = place(A, B, p)
kRef = inv(-C*inv(A-B*K)*B)