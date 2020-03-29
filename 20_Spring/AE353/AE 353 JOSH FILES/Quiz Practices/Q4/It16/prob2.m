clear, clc

syms s
A = [0 0 -3; 4 -5 2; 5 -2 -3];
B = [-4; -4; 4];
C = [0 0 4];
D = [0];

w = 9.9;

H = simplify(C*inv(s*eye(size(A)) - A)*B);  Hw = double(subs(H, s, j*w));

mag = abs(Hw)
theta = angle(Hw)