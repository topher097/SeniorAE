clear, clc

syms s
w = 2.1;
A = [-1 0 -3; 5 -1 -5; -2 5 -2];
B = [3; 5; 1];
C = [2 0 -3];
D = [0];

H = simplify(C*inv(s*eye(size(A)) - A)*B); Hw = double(subs(H, s, j*w));
mag = abs(Hw)
theta = angle(Hw)