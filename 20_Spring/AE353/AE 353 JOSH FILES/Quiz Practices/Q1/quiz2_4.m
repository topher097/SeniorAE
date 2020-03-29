clear, clc
syms t

eqn1 = [(28*sin(t) - 3*cos(t))*exp(8*t); (227*sin(t) + 4*cos(t))*exp(8*t)];
eqn2 = [(-6*t + 1)*exp(7*t) ; (-42*t + 1)*exp(7*t)];
eqn3 = [(35*t - 8)*exp(5*t); (175*t - 5)*exp(5*t)];
eqn4 = [(5*sin(6*t)/6 + 2*cos(6*t))*exp(-t); (-77*sin(6*t)/6 + 3*cos(6*t))*exp(-t)];
eqn5 = [(79*t + 8)*exp(-10*t); (-790*t - 1)*exp(-10*t)];

%{
 Look at the values of the exponents.  eqn 5 has exp(-10*t) which is
 similar to the... eigenvalues of A: s1 = -10, s2 = -10.
%}