clear, clc
%% Insert Provided data:
A = [0 1; 5 -1];
B = [0; 3];
C = [1 0];
K = [8 2];
L = [9; 22];
%% Calculations:
syms s
kRef = kRef(A,B,C,K);
F = simplify((K*inv(s*eye(size(A)) - (A-B*K - L*C)) * B*kRef - kRef) / (-K*inv(s*eye(size(A)) - (A-B*K - L*C)) * L))
G = simplify(K*inv(s*eye(size(A)) - (A-B*K-L*C))*L)
H = simplify(C*inv(s*eye(size(A)) - A)*B)
