clear, clc
%% Insert provided data here:
A = [0.00 1.00; 0.00 0.00];
B = [0.00; 1.00];
C = [1.00 0.00];
x2Max = 0.28;

%% Calculations -- do not modify:
m = 6.55;

Q = [1 0; 0 m];
R = [1];
[K,p] = lqr(A,B,Q,R);
Am = A-B*K;
kRef = 1/(-C*inv(Am)*B);
Bm = B*kRef;
t = linspace(0,10,1000);
x = zeros(2,length(t));
for i = 1:length(t)
    x(:,i) = inv(Am)*(expm(Am*t(i))-eye(length(Am)))*Bm;
end
max(abs(x(2,:)))/norm(R)

