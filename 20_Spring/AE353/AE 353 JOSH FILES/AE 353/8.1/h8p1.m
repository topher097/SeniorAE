%% 8.1.3
clear;
clc;

A = [5 3; -4 1];
B = [1; 3];
C = [2 2];
D = [0];

syms s
H = simplify(C * inv(s * eye(size(A)) - A) * B)

%% 8.1.4
clear; clc;
syms s;

A = [0 5; -5 3];
B = [-1; 5];
C = [-4 -5];
K = [5 2];
L = [3; -4];

H = -K*inv(s*eye(size(A)) - (A - B*K - L*C))*L
%% 8.1.5
clear; clc;
syms s;

numerator = 20;
denominator = s+2;
H = numerator/denominator;

w = 45.4;
H_at_w = double(subs(H, s, j*w))
M = abs(H_at_w)
theta = angle(H_at_w)

%% 8.1.6
clear; clc;
A = [-4 -3; 2 -3];
B = [2; 4];
C = [-4 -2];
D = [0];
syms s
H = simplify(C * inv(s * eye(size(A)) - A) * B)

w = 7.6;
H_at_w = double(subs(H, s, j*w))
M = abs(H_at_w)
theta = angle(H_at_w)