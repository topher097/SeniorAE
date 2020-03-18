A1 = [6.0 -33.9 97.7 2.0; 3.5 -20.7 61.2 2.6; 0.9 -5.4 16.1 0.8; -8.5 46.2 -131.9 -1.8];
A2 = [-0.1 3.3 -0.2; -0.8 -0.1 -1.6; -0.3 -1.5 -0.6];
A3 = [-0.5 0.1 0.0; 0.1 0.0 0.0; 1.5 -0.3 0.0];
A4 = [1.1 1.1; -0.6 -0.6];
A5 = [-0.4 2.0; 0.0 0.0];
C1 = [-3.6 19.3 -54.6 -0.4];
C2 = [-0.3 0.2 -0.7];
C3 = [-0.1 0.1 -0.1];
C4 = [0.1 0.1];
C5 = [-0.1 0.5];

det(obsv(A1,C1))
det(obsv(A2,C2))
det(obsv(A3,C3))
det(obsv(A4,C4))
det(obsv(A5,C5))