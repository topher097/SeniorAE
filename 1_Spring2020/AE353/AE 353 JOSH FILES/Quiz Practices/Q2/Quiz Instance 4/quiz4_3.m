clear, clc

A1 = [45.5 -16.6 9.5 1.3; 124.6 -45.2 26.1 3.6; 145.9 -59.0 27.9 3.2; -1118.1 424.2 -226.1 -29.2];
B1 = [-0.5; -1.2; -0.9; 9.4];
A2 = [5.3 -1.1 0.8; 11.1 -2.0 1.9; -21.2 4.4 -3.2];
B2 = [0.0; 0.0; 0.1];
A3 = [-292.4 -606.0 -229.1 78.9; -926.0 -1920.6 -726.0 250.0; 3355.1 6955.6 2629.4 -905.4; 1544.2 3198.8 1209.3 -416.3];
B3 = [3.7; 11.8; -42.6; -19.4];
A4 = [3.0 0.1 1.6; -10.8 -0.6 -5.3; -6.0 -0.2 -3.2];
B4 = [0.0; -0.1; 0.0];
A5 = [64.9 73.8 -139.4 52.0; 307.8 352.0 -662.4 247.0; 1665.3 1904.0 -3583.6 1336.3; 3946.2 4512.0 -8492.0 3166.6];
B5 = [-0.2; -1.2; -6.6; -15.7];

I1 = det(ctrb(A1, B1))
I2 = det(ctrb(A2, B2))
I3 = det(ctrb(A3, B3))
I4 = det(ctrb(A4, B4))
I5 = det(ctrb(A5, B5))