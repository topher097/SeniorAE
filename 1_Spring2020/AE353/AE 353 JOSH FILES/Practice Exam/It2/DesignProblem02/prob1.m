clear, clc
load('DesignProblem02_EOMs.mat')

M = symEOM.M;
C = symEOM.C;
N = symEOM.N;
tau = symEOM.tau;
D = zeros(length(C));

syms tau1 q1 q2 v1 v2 real



q = [q1; q2; v1; v2];
qD = [v1; v2];
T = [tau1; 0];
qDD = M\(-C*qD - N + T);
A = [0 0 1 0 ; 0 0 0 1; simplify(jacobian(qDD, q))];
B = [0; 0; jacobian(qDD, tau1)];

A = subs(A, q1, 0); A = subs(A, q2, 0); A = subs(A, v1, 0); A = subs(A, v2, 0);
A = double(A)
B = subs(B, tau1, 0); B = subs(B, q2, 0);
B = double(B)

C = eye(4)
D = zeros(size(C))'