clear, clc
%% Insert provided data:
A = [-0.30 0.70 -0.80; -0.80 0.80 0.00; -0.60 -0.10 0.60];
B = [0.70; -0.50; 0.90];
C = [0.10 -0.70 -0.40];
pObsv = [-3.00+0.00j -5.00-4.00j -5.00+4.00j];
pCont = [-4.00+0.00j -1.00-1.00j -1.00+1.00j];

%% Calculations -- do not modify
transL=acker(transpose(A),transpose(C),pObsv);
L=transpose(transL);
K=acker(A,B,pCont);

kref = -1/(C*inv(A-B*K)*B);
F=[A-B*K -B*K;zeros(size(A)) A-L*C];
v=transpose(eig(F));

L = mat2str(L)
K = mat2str(K)
kRef = kref
p = mat2str(v)