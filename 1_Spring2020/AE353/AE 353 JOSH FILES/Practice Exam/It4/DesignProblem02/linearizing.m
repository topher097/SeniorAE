%% Loading EOMs
load('DesignProblem02_EOMs.mat')
%% Inserting provided data
Qo = [0.60];
Ro = [4.00 0.10 0.10 -0.35; 0.10 3.60 0.65 -0.25; 0.10 0.65 4.90 0.60; -0.35 -0.25 0.60 3.40];
Qc = [3.50 0.45 -0.60 -0.20; 0.45 3.60 -0.30 0.35; -0.60 -0.30 4.20 -0.45; -0.20 0.35 -0.45 4.70];
Rc = [1.30];
syms s
%% Equilibrium Points
M = symEOM.M; C = symEOM.C; N = symEOM.N; tau = symEOM.tau;
syms q1 q2 v1 v2 tau1 real

q = [q1; q2];
qD = [v1; v2];

q1 = pi;
q2 = 0.34;
v1 = 0;
v2 = 0;

eqM = [pi; 0.34; 0; 0];
eqN = [-6.48];
u = [tau1];
y = [q2];

qDD = inv(M)*(tau-C*qD-N);
x = [q; qD];
xD = [qD; qDD];

A = jacobian(xD, x);
B = jacobian(xD, u);
C = jacobian(y, x);

A = double(subs(A, [x; u], [eqM; eqN]));
B = double(subs(B, [x;u], [eqM; eqN]));
C = [0 1 0 0];

L = lqr(A', C', inv(Ro), inv(Qo))';
K = lqr(A, B, Qc, Rc);
kRef = inv(-C*inv(A-B*K)*B);

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

disp('A = '); disp(mat2str(A))
disp('B = '); disp(mat2str(B))
disp('C = '); disp(mat2str(C))
disp('L = '); disp(mat2str(L))
disp('K = '); disp(mat2str(K))
disp('kRef = '); disp(kRef)
disp('tau = '); disp(tau)