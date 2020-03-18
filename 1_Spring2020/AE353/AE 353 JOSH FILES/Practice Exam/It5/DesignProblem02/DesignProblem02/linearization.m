clear, clc
%% Initializing things
syms tau1 q1 q2 v1 v2 real
load('DesignProblem02_EOMs.mat')
M = symEOM.M; C = symEOM.C; N = symEOM.N; tau = symEOM.tau;

q = [q1; q2];
qD = [v1; v2];

%% Equilibrium points
q1 = pi;
q2 = 0;
v1 = 0;
v2 = 0;
tauE = subs(N, [q; qD], [[q1; q2]; [v1; v2]])

eqM = [pi; 0; 0; 0];
eqN = [tauE(1)];


u = [tau1];
y = [q2];

qDD = inv(M)*(tau-C*qD - N);
x = [q; qD];
xD = [qD; qDD];

A = double(subs(jacobian(xD, x), [x; u], [eqM; eqN]));
B = double(subs(jacobian(xD, u), [x; u], [eqM; eqN]));
C = [0 1 0 0];

disp('A = '); disp(mat2str(A)); disp(' ');
disp('B = '); disp(mat2str(B)); disp(' ');
disp('C = '); disp(mat2str(C)); disp(' ');

%% Observer Design
Qo = [0.40];
Ro = [4.50 0.75 0.20 -0.05; 0.75 3.60 -0.10 -0.35; 0.20 -0.10 3.90 -0.50; -0.05 -0.35 -0.50 4.80];

L = lqr(A', C', inv(Ro), inv(Qo))';
disp('L = '); disp(mat2str(L));

%% Controller Design
Qc = [3.10 0.45 0.45 0.25; 0.45 3.50 0.30 0.50; 0.45 0.30 3.10 -0.70; 0.25 0.50 -0.70 3.80];
Rc = [0.60];

K = lqr(A, B, Qc, Rc);
kRef = inv(-C*inv(A-B*K)*B);
disp('K = '); disp(mat2str(K));
disp('kRef = '); disp(mat2str(kRef));

%% Time delay analysis:
syms s
F = simplify((K*inv(s*eye(size(A)) - (A-B*K-L*C))*B*kRef - kRef) / (-K*inv(s*eye(size(A)) - (A-B*K-L*C))*L));
G = simplify(K*inv(s*eye(size(A)) - (A-B*K-L*C))*L);
H = simplify(C*inv(s*eye(size(A)) - A)*B);

stability = true;
tau = 0;

while stability == true
    tD = (2-s*tau) / (2+s*tau);
    T = simplify((-F*G*H*tD) / (1 + H*G*tD));
    
    [N,D] = numden(T); stab = roots(double(flip(coeffs(D))));
    for i=1:length(stab)
        if stab(i) > 0
            disp(tau)
            stability=false;
            break
        else
            tau = tau+0.00001;
        end
    end
end
    