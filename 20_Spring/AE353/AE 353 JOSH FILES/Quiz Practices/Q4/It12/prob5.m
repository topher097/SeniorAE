clear, clc

syms s
A = [0 1; -2 -1];
B = [0; 2];
C = [1 0];
K = [0 1];
L = [7; 32];

kRef = inv(-C*inv(A-B*K)*B);

F = simplify((K*inv(s*eye(size(A)) - (A-B*K-L*C))*B*kRef - kRef) / (-K*inv(s*eye(size(A)) - (A-B*K-L*C))*L))
G = simplify(K*inv(s*eye(size(A)) - (A-B*K-L*C))*L)
H = simplify(C*inv(s*eye(size(A)) -A)*B)