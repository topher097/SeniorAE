clear, clc  %WOKE
%% Insert Provided Data here


%% Calculations
syms k1 k2 k3 s real
s = s.*eye(length(A));

%% Pick your K locations -- EDIT
K = [k1 0 k3; k2 0 0];

%% Symbolic equations -- do not edit
eqn = det(-A+B*K + s)

%% Coefficients
coef = poly(p);
coef = coef(2:end);

%% Choose equations based on coefficients for s -- EDIT
eqn1 = 2 + k3 + k1 == coef(1);
eqn2 = 1 - 2*k2 == coef(2);
eqn3 = -2*k2 - k1 -k2*k3 == coef(3);

%% Solve -- do not edit
sol = solve([eqn1, eqn2, eqn3], [k1, k2, k3]);
k1 = sol.k1;
k2 = sol.k2;
k3 = sol.k3;

K = [vpa(k1(1)) 0 vpa(k3(1)) ; vpa(k2(1)) 0 0]