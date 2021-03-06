clear, clc

A1 = [-0.1 0.2; -0.1 0.2];
A2 = [2.8 -11.2; 0.6 -2.4];
A3 = [6.4 -22.1 -42.6 -85.2; 1.9 2.6 6.2 12.4; 2.3 -13.6 -27.1 -54.2; -1.2 4.6 9.0 18.0];
A4 = [23.7 -106.9 -601.8 -601.8; -64.3 280.5 1588.9 1588.9; 20.8 -90.3 -512.2 -512.2; -8.5 36.5 207.6 207.6];
A5 = [-297.1 -359.9 481.2 481.2; 160.3 194.1 -259.9 -259.9; -63.3 -76.7 102.3 102.3; 0.2 0.2 -0.3 -0.3];
C1 = [-0.3 0.7];
C2 = [0.1 -0.4];
C3 = [-0.3 0.9 1.7 3.4];
C4 = [1.9 -8.2 -46.6 -46.6];
C5 = [-2.0 -2.4 3.3 3.3];

obs1 = det(obsv(A1, C1))
obs2 = det(obsv(A2, C2))
obs3 = det(obsv(A3, C3))
obs4 = det(obsv(A4, C4))
obs5 = det(obsv(A5, C5))