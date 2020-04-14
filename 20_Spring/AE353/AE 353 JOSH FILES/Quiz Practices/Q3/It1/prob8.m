clear, clc

A1 = [32.9 7.4 -91.3; -16.3 -3.7 45.2; 10.7 2.4 -29.7];
A2 = [11.3 45.2; -2.7 -10.8];
A3 = [6.6 17.8 35.6; 9.1 24.8 49.6; -5.7 -15.5 -31.0];
A4 = [-1.5 -6.7 -40.3 -13.4; 5.8 26.9 150.1 53.8; -1.9 -8.8 -48.5 -17.6; 2.6 12.0 65.6 24.0];
A5 = [-1.6 3.2; -0.7 1.4];
C1 = [-0.5 -0.2 1.2];
C2 = [0.4 1.7];
C3 = [-0.2 -0.5 -1.0];
C4 = [0.4 1.8 10.1 3.6];
C5 = [-0.3 0.7];

observable1 = det(obsv(A1, C1))
observable2 = det(obsv(A2, C2))
observable3 = det(obsv(A3, C3))
observable4 = det(obsv(A4, C4))
observable5 = det(obsv(A5, C5))