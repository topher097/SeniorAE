function FindCost
A = [0.80 -0.10 0.10; 0.20 -0.40 0.00; -0.40 -0.30 -0.30];
B = [0.90 0.50 0.10; 0.20 -0.20 0.80; 0.60 0.90 -0.20];
Q = [2.30 -0.20 -0.85; -0.20 3.30 -0.15; -0.85 -0.15 3.50];
R = [2.40 -0.80 0.00; -0.80 3.10 0.55; 0.00 0.55 3.60];
t0 = 1.00;
x0 = [-0.60; -0.90; -0.35];
[K,P] = lqr(A,B,Q,R)
cost = integral(@(t) integrand(t, A, B, K, t0, x0, Q, R), t0, Inf);
disp(mat2str(cost, 8));
end

function cost = integrand(t, A, B, K, t0, x0, Q, R)
cost = zeros(size(t));
for i = 1:length(t)
    x = expm((A - B * K) * (t(i) - t0)) * x0;
    u = -K * x;
    cost(i) = transpose(x)*Q*x + transpose(u)*R*u;
end
end