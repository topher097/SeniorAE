clear, clc
%% Provided data
A = [0 1; 5 1];
B = [0; 1];
C = [1 0];
K = [13 7];
L = [10; 35];
syms s

%% Calculation
kRef = inv(-C*inv(A-B*K)*B);
F = simplify((K*inv(s*eye(size(A)) - (A-B*K - L*C)) * B*kRef - kRef) / (-K*inv(s*eye(size(A)) - (A-B*K-L*C)) * L))
G = simplify(K*inv(s*eye(size(A)) - (A-B*K-L*C))*L)
H = simplify(C*inv(s*eye(size(A)) - A)*B)