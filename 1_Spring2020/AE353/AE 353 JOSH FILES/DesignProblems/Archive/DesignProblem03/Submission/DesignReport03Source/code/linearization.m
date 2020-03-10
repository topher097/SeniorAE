clear, clc
%% Initialize:
load('DesignProblem03_EOMs.mat');
f = symEOM.f;
syms theta phi xdot ydot thetadot phidot real

v = [theta; phi; xdot; ydot; thetadot; phidot];
f_numeric = matlabFunction(f, 'vars', {v})

v_guess = [1; 2; 10; 1; 0; 0];
f_numeric_at_v_guess = f_numeric(v_guess)

% With default options
[v_sol, f_numeric_at_v_sol, exitflag] = fsolve(f_numeric, v_guess)

%% Linearize:
if exitflag == 1
    x = [theta; phi; xdot; ydot; thetadot];
    u = [phidot];
    y = [theta; phi];
    xD = [thetadot; phidot; f(1); f(2); f(3)];

    thetaE = v_sol(1); phiE = v_sol(2); xdotE = v_sol(3); ydotE = v_sol(4); thetadotE = v_sol(5); phidotE = v_sol(6);
    equiPoints = [thetaE; phiE; xdotE; ydotE; thetadotE; phidotE];
    A = jacobian(xD, x); A = double(vpa(subs(A, [x; phidot], equiPoints),6))
    B = jacobian(xD, u); B = double(vpa(subs(B, [x; phidot], equiPoints),6))
    C = double(jacobian(y, x))
    D = jacobian(y, u);
    
    ControllabilityCondition = cond(ctrb(A,B))
    ObservabilityCondition = cond(obsv(A,C))
else
    disp('not valid v_guess')
end
    