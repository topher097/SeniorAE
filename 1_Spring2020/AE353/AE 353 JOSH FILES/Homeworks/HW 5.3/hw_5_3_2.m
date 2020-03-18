clear, clc
%% Insert Provided data here:
A = 0.10;
B = -0.40;
Q = 5.40;
R = 6.40;
M = 1.00;
t0 = 0.40;
x0 = -0.68;
t1 = 0.40;

%% Calculations -- do not modify
syms P(t)
ode1 = diff(P) == P*B*inv(R)*transpose(B)*P-P*A - transpose(A)*P - Q;
odes = [ode1];
cond1 = P(t1) == M;
conds=[cond1];
S = (dsolve(odes, conds));
t = (t0);
d = subs(S);
K = inv(R)*transpose(B)*d;

Am = A-B*K;
xt1 = expm(Am*(t1-t0))*x0;
Const = M*xt1^2;

intt=testIntegration(t0, t1, Am, Q,R,x0,K);
cost= eval(Const+intt)

function y=g(t, Am, Q, R, x0, K, t0)
    for i=1:length(t)
        xt = expm(Am*(t(i) - t0))*x0;
        u = -K*xt;
        y(i) = eval(transpose(xt)*Q*xt+transpose(u)*R*u);
    end
end
function intt = testIntegration(t0, t1, Am, Q, R, x0, K)
    syms t real
    intt = integral(@(t) g(t, Am, Q, R, x0, K, t0), t0, t1)
end