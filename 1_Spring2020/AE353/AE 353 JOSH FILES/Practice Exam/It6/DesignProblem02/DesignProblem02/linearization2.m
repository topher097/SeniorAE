clear, clc
load('DesignProblem02_EOMs.mat')
syms q1 q2 v1 v2 tau1 real
M = symEOM.M; C = symEOM.C; N = symEOM.N; tau = symEOM.tau;

q = [q1; q2];
qD = [v1; v2];

q1 = pi;
q2 = 0.53;
v1 = 0;
v2 = 0;

tauE = subs(symEOM.N, [q; qD], [[q1; q2]; [v1; v2]]); disp('TauE = '); disp(vpa(tauE(1))); disp(' ');

eqM = [pi; 0.53; 0; 0];
eqN = [tauE(1)];

u = [tau1];
y = [q2];

qDD = inv(M)*(tau - C*qD - N);
x = [q; qD];
xD = [qD; qDD];

A = double(subs(jacobian(xD, x), [x; u], [eqM; eqN]));
B = double(subs(jacobian(xD, u), [x; u], [eqM; eqN]));
C = [0 1 0 0];

disp('A = '); disp(mat2str(A)); disp(' ');
disp('B = '); disp(mat2str(B)); disp(' ');
disp('C = '); disp(mat2str(C)); disp(' ');

%% Observer design
Qo = [0.60];
Ro = [4.90 0.15 -0.20 0.35; 0.15 3.60 0.60 0.25; -0.20 0.60 3.40 -0.75; 0.35 0.25 -0.75 4.50];

L = lqr(A', C', inv(Ro), inv(Qo))';
disp('L = '); disp(mat2str(L)); disp(' ');

%% Controller design
Qc = [3.80 -0.20 0.70 0.45; -0.20 3.80 0.50 0.40; 0.70 0.50 4.20 0.35; 0.45 0.40 0.35 4.10];
Rc = [0.80];

K = lqr(A, B, Qc, Rc);
disp('K = '); disp(mat2str(K)); disp(' ');
kRef = inv(-C*inv(A-B*K)*B);
disp('kRef = '); disp(mat2str(kRef)); disp(' ');

%% TauMax
