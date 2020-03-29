clear, clc
%% Insert Provided Data:
syms s
F = input('F = ');
G = input('G = ');
H = input('H = ');
%% Calculations
stability = true;
tau = 0;
while stability == true
    tDelay = (2 - s*tau) / (2 + s*tau);

    T = simplify((-F*G*H*tDelay) / (1 + H*G*tDelay));

    [N, D] = numden(T);
    denom = double(flip(coeffs(D)));
    stab = vpa(roots(flip(denom)),2);
    
    for i=1 : length(stab)
        if stab(i) > 0
            tau
            stability = false;
            break
        else
            tau = tau+0.0001;
        end
    end
end