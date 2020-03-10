clear
clc
A = 0.10;
B = 0.30;
Q = 6.10;
R = 5.40;
M = 0.50;
t0 = 0.90;
x0 = 0.92;
t1 = 1.20;

syms P(t)
ode1=diff(P) == P*B*inv(R)*transpose(B)*P-P*A-transpose(A)*P-Q;
odes=[ode1];
cond1=P(t1)==M;
conds=[cond1];
S=(dsolve(odes,conds));
t=(t0);
d=subs(S);
K=inv(R)*transpose(B)*d;

Am=A-B*K;
xt1=expm(Am*(t1-t0))*x0;
Const=M*xt1^2;

intt=testIntegration(t0,t1,Am,Q,R,x0,K);
cost=eval(Const+intt)

function y=g(t,Am,Q,R,x0,K,t0)
    
    for i=1:length(t)
        xt=expm(Am*(t(i)-t0))*x0;
        u=-K*xt;
        y(i)=eval(transpose(xt)*Q*xt+transpose(u)*R*u);
    end
end
function intt=testIntegration(t0,t1,Am,Q,R,x0,K)
    syms t real
    intt=integral(@(t) g(t,Am,Q,R,x0,K,t0),t0,t1)
end