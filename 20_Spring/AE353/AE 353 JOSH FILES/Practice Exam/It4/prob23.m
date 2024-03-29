clear, clc
%% Insert provided data
A1 = [3.9 -19.5; 0.8 -4.0];
A2 = [-0.8 0.3 0.0; -0.4 -0.1 0.0; 4.9 -3.0 0.0];
A3 = [70.9 40.5 -167.2 851.1; 25.7 14.2 -60.7 308.4; -89.7 -50.0 212.1 -1077.8; -24.8 -13.9 58.6 -297.9];
A4 = [-1.1 2.2 -8.8; 36.8 -140.2 560.8; 9.3 -35.3 141.2];
A5 = [-3.6 -18.0; 0.7 3.5];
C1 = [-0.1 0.5];
C2 = [-0.3 0.1 -0.1];
C3 = [-6.4 -3.8 14.9 -76.1];
C4 = [-0.4 1.5 -6.0];
C5 = [-0.5 -2.6];

%% Calculations
obsv1 = cond(obsv(A1, C1))
obsv2 = cond(obsv(A2, C2))
obsv3 = cond(obsv(A3, C3))
obsv4 = cond(obsv(A4, C4))
obsv5 = cond(obsv(A5, C5))