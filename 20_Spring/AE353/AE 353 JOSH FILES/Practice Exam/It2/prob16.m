clear, clc

A1 = [35.8 27.4 8.5 -6.6; -213.6 -159.3 -49.5 39.2; 798.8 593.1 184.4 -146.6; 337.0 252.2 78.4 -62.0];
B1 = [1.5; -8.1; 29.8; 12.9];
A2 = [2.3 0.4; -11.5 -2.0];
B2 = [0.2; -1.1];
A3 = [16.4 -3.0 4.7 -13.2; -12.1 2.7 -3.6 11.1; -67.3 12.8 -19.4 54.3; 0.0 0.0 0.0 0.0];
B3 = [-0.3; 0.3; 1.3; 0.0];
A4 = [89.9 15.3 -187.8 -52.3; 387.7 65.7 -810.7 -225.6; -201.0 -34.4 422.3 117.5; 990.7 168.9 -2077.6 -578.1];
B4 = [5.8; 25.3; -13.2; 64.8];
A5 = [3.8 1.1; -11.4 -3.3];
B5 = [-0.3; 1.0];

controllable1 = det(ctrb(A1,B1))
controllable2 = det(ctrb(A2, B2))
controllable3 = det(ctrb(A3, B3))
controllable4 = det(ctrb(A4, B4))
controllable5 = det(ctrb(A5, B5))

% tol- e-08 uncontroll
