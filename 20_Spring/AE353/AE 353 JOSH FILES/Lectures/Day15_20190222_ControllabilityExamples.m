%% Pitch motion of SC

clear
clc

Jpitch = 15;
Jwheel = 1;
n = 0.0011;
Jroll = 15;
Jyaw = 5;


% % ORIGINAL
% A = [0 1; 0 0];
% B = [0; 1/Jpitch];

% % WITH REACTION WHEEL
% A = [0 1 0; 0 0 0; 0 0 0]
% B = [0; 1/Jpitch; -1/Jwheel]

% WITH REACTION WHEEL AND GRAVITY-GRADIENT TORQUE
A = [0 1 0; 3*n^2*(Jyaw-Jroll)/Jpitch 0 0; 0 0 0]
B = [0; 1/Jpitch; -1/Jwheel]

W = ctrb(A, B)
det(W)
rank(W)

K = acker(A, B, [-1, -2, -3])
% K = acker(A, B, [-2, -3])

