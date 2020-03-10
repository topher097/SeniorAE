clear, clc

syms s
A = [0 1; 1 -5];
B = [0; 2];
C = [1 0];
K = [8 2];
L = [5; 1];

kRef = inv(-C*inv(A-B*K)*B);

F = simplify((K*inv(s*eye(size(A)) - (A-B*K-L*C)) * B*kRef - kRef) / (-K*inv(s*eye(size(A)) - (A-B*K-L*C))*L))
G = simplify(K*inv(s*eye(size(A)) - (A-B*K-L*C))*L)
H = simplify(C*inv(s*eye(size(A)) - A)*B)