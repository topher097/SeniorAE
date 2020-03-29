clear, clc
%% Insert provided data here:
A1 = [-1.5 -1.5; 1.1 1.1];
A2 = [-0.5 0.5 0.0; 3.4 -8.4 -15.0; -2.1 5.0 8.7];
A3 = [0.3 0.6; -0.1 -0.2];
A4 = [52.3 116.0 520.8 464.0; -66.7 -148.5 -660.1 -594.0; -11.9 -26.4 -118.8 -105.6; 24.1 53.6 239.3 214.4];
A5 = [150.9 -174.2 -791.9 -2399.0; 30.6 -35.7 -160.2 -485.7; 118.8 -138.5 -622.6 -1887.5; -31.9 37.3 167.1 506.7];
C1 = [0.1 0.1];
C2 = [0.7 -1.6 -2.8];
C3 = [0.4 0.7];
C4 = [-1.0 -2.2 -9.9 -8.8];
C5 = [-6.8 7.8 35.6 107.9];

%% Calculations -- do not modify:
% Choose whatever is a small number, anything basically zero is not it
Observable1 = det(obsv(A1, C1))
Observable2 = det(obsv(A2, C2))
Observable3 = det(obsv(A3, C3))
Observable4 = det(obsv(A4, C4))
Observable5 = det(obsv(A5, C5))