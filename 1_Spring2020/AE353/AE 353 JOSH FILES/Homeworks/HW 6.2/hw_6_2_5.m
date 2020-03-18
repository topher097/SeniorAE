clear, clc
%% Insert provided data:
A = [0.30 -0.80 -0.10 0.80; 0.10 0.70 -0.50 -0.10; -0.80 0.70 0.60 0.20; 0.50 0.80 0.30 0.40];
B = [-0.70; -0.80; -0.20; -0.30];
C = [-0.70 -0.30 -0.70 0.80];
pObsv = [-1.00-4.00j -1.00+4.00j -2.00+0.00j -3.00+0.00j];
pCont = [-1.00 -4.00 -1.00 -4.00];

%% Calculations -- do not modify
transL=acker(transpose(A),transpose(C),pObsv);
L=transpose(transL);
K=acker(A,B,pCont);

kref=kRef(A,B,C,K);
F=[A-B*K -B*K;zeros(size(A)) A-L*C];
v=transpose(eig(F));

L = mat2str(L)
K = mat2str(K)
kRef = kref
p = mat2str(v)