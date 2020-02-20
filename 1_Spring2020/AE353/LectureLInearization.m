clc;
clear;

mass = 1; 
gravity = 9.81;

syms z zdot thrust real
f = [zdot; (thrust - mass * gravity) / mass];

ze = 1;
zdote = 0;
thruste = mass * gravity;

% Double turns the symbolic expression into a floating point matrix
A = double(subs(jacobian(f, [z; zdot]), [z; zdot; thrust], [ze; zdote; thruste]));
B = double(subs(jacobian(f, [z; thrust]), [z; zdot; thrust], [ze; zdote; thruste]));

disp(A)
disp(B)

K = [10 7];

Am = A - B * K;

% Initial condition
syms t real
x0 = [-1; 0];
[V, F] = eig(Am);
xdot = V * expm(F * t) * inv(V) * x0;
xdot = expm(Am * t) * x0;


