clear, clc

syms s
A = [2 3; -3 -3];
B = [3; -4];
C = [-3 2];
D = [0];
w = 8.8;

H = simplify(C*inv(s*eye(size(A)) - A)*B); Hw = double(subs(H, s, j*w));
mag = abs(Hw)
theta = angle(Hw)