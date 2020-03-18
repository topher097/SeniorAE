clear, clc
%% Insert provided data:
A = [0 1; -5 3];
B = [0; 2];
C = [1 0];
K = [6 4];
L = [10; 35];
syms s
%% Calculations
kRef = inv(-C*inv(A-B*K)*B);
F = simplify((K*inv(s*eye(size(A)) - (A-B*K - L*C)) * B*kRef - kRef) / (-K*inv(s*eye(size(A)) - (A-B*K - L*C)) * L));
G = simplify(K*inv(s*eye(size(A)) - (A-B*K-L*C))*L);
H = simplify(C*inv(s*eye(size(A)) - A)*B);

%% Stability Test
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
