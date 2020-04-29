clear, clc
%% Insert provided data:
syms s
F = input('F = ');
G = input('G = ');
H = input('H = ');
%% Calculations:
T = simplify((-H*G) / (1+H*G))

[N, D] = numden(T);
denom = double(flip(coeffs(D)));
stab = vpa(roots(flip(denom)),2);
n = 0;
for i=1 : length(stab)
    if stab(i) < 0
        n = n+1;
    else
        break
    end
end
if n == length(stab)
    disp('Sys stable')
else
    disp('Sys Not Stable')
end