clear, clc

syms s
A = [-2 4 5; -4 -4 -5; -4 4 2];
B = [4; 2; 5];
C = [5 3 1];
D = [0];

w = 6.9;

H = simplify(C*inv(s*eye(size(A)) - A)*B); Hw = double(subs(H, s, j*w));
mag = abs(Hw)
theta = angle(Hw)