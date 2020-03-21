clc;
clear all;

syms MAC x y l theta Croot Ctip Gamma b 
r = sin(Gamma)*b/2;
t = r + Ctip - Croot;
eq1 = x + MAC + l == Croot + t;
eq2 = l == tan(theta)*(b/2 - y);
eq3 = x == tan(Gamma)*y;
eq4 = theta == atan((r+Ctip-Croot)/(b/2));


ans = solve([eq1, eq2, eq3, eq4], 'ReturnConditions', true);
ans2 =  solve([eq1, eq2, eq3, eq4], y)
disp(ans.y);