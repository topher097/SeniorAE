clear, clc

syms s
A = [-2 4; 1 -4];
B = [4; 5];
C = [3 -2];
D = [0];

w = 2.5;

H = simplify(C*inv(s*eye(size(A)) - A)*B); Hw = double(subs(H, s, j*w));

mag = abs(Hw)
theta = angle(Hw)