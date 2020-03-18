clear, clc

A1 = [-2.5 1.5 -2.5; 0.8 -0.5 0.8; 2.9 -1.8 2.9];
A2 = [-0.1 -0.3; 0.0 0.0];
A3 = [-42.4 14.8 29.9 -97.9; -69.5 22.4 57.1 -176.0; -4.6 -0.4 12.0 -27.4; 6.1 -3.0 -0.5 6.8];
A4 = [-12.4 -28.8 110.8 443.2; -3.7 -7.9 32.1 128.4; 28.8 70.2 -260.8 -1043.2; -7.8 -18.9 70.5 282.0];
A5 = [47.9 230.4 -230.4; -7.7 -37.1 37.1; 2.3 11.0 -11.0];
C1 = [-0.1 0.0 -0.1];
C2 = [-0.1 -0.2];
C3 = [-1.4 0.6 0.5 -2.4];
C4 = [0.6 1.3 -5.2 -20.8];
C5 = [-0.3 -1.4 1.4];

obsv1 = det(obsv(A1, C1))
obsv2 = det(obsv(A2, C2))
obsv3 = det(obsv(A3, C3))
obsv4 = det(obsv(A4, C4))
obsv5 = det(obsv(A5, C5))