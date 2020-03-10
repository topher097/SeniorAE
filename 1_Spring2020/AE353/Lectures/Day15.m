%% System 1
clc;
clear;
J_p = 15;
A = [0 1; 0 0];
B = [0; 1/J_p];

W = ctrb(A, B);
disp(W);
disp(rank(W));

%% System 2
clc;
clear;
J_w = 1;
J_p = 15;
A = [0 1 0; 0 0 0; 0 0 0];
B = [0; 1/J_p; -1/J_w];

W = ctrb(A, B);
disp(W);
disp(rank(W));

K = acker(A, B, [-1 -2 -3]);
disp(K);

%% System 3
clc;
clear;
J_w = 1;
J_p = 15;
J_y = 5;
J_r = 15;
n = 0.0011;
A = [0 1 0; 3*n^2*(J_y-J_r) 0 0; 0 0 0];
B = [0; 1/J_p; -1/J_w];

W = ctrb(A, B);
disp(W);
disp(rank(W));

K = acker(A, B, [-1 -2 -3]);
disp(K);