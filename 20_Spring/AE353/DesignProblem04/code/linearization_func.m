function x = linearization_func(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r)    
    load('DP04 eom.mat');
    Q = symEOM.f;
    bm = 0.4;        % meters
    rm = 0.2;        % meters
    roadwidth = 3;  % meters
    v_road = .25;   % guess
    r_road = 0;     % guess
    w_road = 0;   

    syms elateral eheading phi phidot v w tauR tauL
    input = [tauR; tauL];
    elateraldot = -v*sin(eheading);
    eheadingdot = w-((v*cos(eheading))/(v_road+w_road*elateral));
    state = [elateral; eheading; phi; phidot; v; w];

    gdot = [elateraldot; eheadingdot; phidot; Q];
    g_numeric = matlabFunction(gdot,'vars',{[elateral; eheading; phi; phidot; v; w; tauR; tauL]});
    % elat ehead phi phidot v w tauR tauL
    equi = [0; 0; 0; 0; v_road; w_road; 0; 0]; 

    opts = optimoptions(@fsolve,'Algorithm','levenberg-marquardt','display','off');
    [g_sol, g_numeric_at_f_sol, exitflag] = fsolve(g_numeric,equi,opts);
    equiPoints = g_sol;
    xhat_guess = equiPoints(1:1:6);

    r_road = v_road/w_road;
    dL = (roadwidth*.5+elateral)/(cos(eheading)) - bm/2;
    dR = (roadwidth*.5-elateral)/(cos(eheading)) - bm/2;
    wR = v/rm + (bm*w)/(2*rm);
    wL = v/rm - (bm*w)/(2*rm);

    A = double(subs(jacobian(gdot, state), [elateral; eheading; phi; phidot; v; w; tauR; tauL], g_sol));
    B = double(subs(jacobian(gdot, input), [elateral; eheading; phi; phidot; v; w; tauR; tauL], g_sol));
    ob = [dR; dL; wR; wL];
    C = double(subs(jacobian(ob, state),[elateral; eheading; phi; phidot; v; w; tauR; tauL], g_sol));

%     Qc = diag([1, 100, 100, 10, 50, 1]);  % elat ehead phi phidot v w
%     Rc = diag([1, 1]);              % tuaR tauL
%     Qo = diag([200, 200, 1, 1]);        % dR dL wR wL
%     Ro = diag([1, 10, 1, 1, 1, 1]);  % elat ehead phi phidot v w

    % Use the hill climbing algorithm to find the optimal gains
    Qc = diag([a, b, c, d, e, f]);  % elat ehead phi phidot v w
    Rc = diag([g, h]);              % tuaR tauL
    Qo = diag([i, j, k, l]);        % dR dL wR wL
    Ro = diag([m, n, o, p, q, r]);  % elat ehead phi phidot v w

    K = lqr(A, B, Qc, Rc);
    L = lqr(A', C', inv(Ro), inv(Qo))';
    
    dL_E = (roadwidth*.5+g_sol(1))/(cos(g_sol(2))) - bm/2;
    dR_E = (roadwidth*.5-g_sol(1))/(cos(g_sol(2))) - bm/2;
    wL_E = g_sol(5)/rm - (bm*g_sol(6))/(2*rm);
    wR_E = g_sol(5)/rm + (bm*g_sol(6))/(2*rm);
    y_e = [dR_E; dL_E; wR_E; wL_E];


    save('control.mat', 'A', 'B', 'C', 'K', 'L', 'xhat_guess', 'equiPoints', 'y_e')
end
    

