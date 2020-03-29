clear, clc

A = [0 1; 1 -4];
B = [0; 2];
C = [1 0];
K = [6 1];
L = [6; 18];
syms s

kRef = inv(-C*inv(A-B*K)*B);

F = simplify((K*inv(s*eye(size(A)) - (A-B*K-L*C))*B*kRef - kRef) / (-K*inv(s*eye(size(A)) - (A-B*K-L*C))*L))
G = simplify(K*inv(s*eye(size(A)) - (A-B*K-L*C))*L)
H = simplify(C*inv(s*eye(size(A)) - A)*B)