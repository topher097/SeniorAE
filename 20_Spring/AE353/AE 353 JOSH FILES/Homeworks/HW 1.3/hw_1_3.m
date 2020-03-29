clear, clc
%Create a set of variables
syms x xD xDD u

%Input equilibrium value
xE = input('Equilibrium: ');

%Input the equation of motion/system of equations
%eqn1 = {INSERT YOUR EQUATION HERE};

% xD = [ad; solve(eqn1, add)];
xD = [solve(eqn1, add); ad];

%{
INSERT YOUR x AND u EQUATIONS HERE:
Example:
    x = [ \dot{eta} ; eta];
    u = [u];
    y = [ \dot{eta}];
%}

%Jacobian to find values for A, B, C, D
A = vpa(subs(jacobian(xD, x), xE), 3)
B = jacobian(xD, u)
C = jacobian(y, x)
D = jacobian(y, u)