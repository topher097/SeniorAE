clear, clc

syms s
A = [-5 -4; 3 -4];
B = [1; -2];
C = [2 -1];
D = [0];

w = 0.9;

H = simplify(C*inv(s*eye(size(A)) - A)*B); Hw = double(subs(H, s, j*w));

m = abs(Hw)
theta = angle(Hw)