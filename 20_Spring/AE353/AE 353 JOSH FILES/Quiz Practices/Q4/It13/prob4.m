clear, clc

syms s
A = [-5 3 -3; -3 1 -4; -3 5 -1];
B = [-3; 4; -4];
C = [-3 4 5];
D = [0];

w = 3.6;

H = simplify(C*inv(s*eye(size(A)) - A)*B); Hw = double(subs(H, s, j*w));

mag = abs(Hw)
theta = angle(Hw)