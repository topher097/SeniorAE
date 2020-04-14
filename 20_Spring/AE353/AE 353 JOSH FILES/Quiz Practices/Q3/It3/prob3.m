clear, clc

A1 = [5.9 26.0 -160.6 921.2; 307.0 1138.2 -7245.7 41305.5; -161.3 -596.5 3798.4 -21651.9; -36.8 -136.2 867.2 -4943.4];
A2 = [86.9 -395.7 1472.3 -5976.1; -24.9 114.4 -423.6 1719.3; 1.1 4.9 -1.8 6.1; 3.2 -12.2 49.3 -200.4];
A3 = [1.5 -7.5; 0.2 -1.0];
A4 = [1.5 -1.3 -9.9 19.8; -14.6 10.9 82.3 -164.6; -11.9 9.6 71.3 -142.6; -7.0 5.6 41.7 -83.4];
A5 = [-3.8 8.9 17.8; -10.6 24.7 49.4; 4.6 -10.7 -21.4];
C1 = [-2.9 -10.7 68.3 -389.1];
C2 = [-2.3 11.5 -40.9 166.0];
C3 = [-0.2 1.1];
C4 = [-0.4 0.3 2.1 -4.3];
C5 = [-0.3 0.7 1.4];

observable1 = det(obsv(A1, C1))
observable2 = det(obsv(A2, C2))
observable3 = det(obsv(A3, C3))
observable4 = det(obsv(A4, C4))
observable5 = det(obsv(A5, C5))