clear, clc

A = [0 1; 5 2];
B = [0; 3];
C = [1 0];
K = [5 3];
L = [8; 29];

syms s

kRef = inv(-C*inv(A-B*K)*B);
F = simplify((-K*inv(s*eye(size(A))-(A-B*K - L*C)) * B*kRef - kRef) / (-K*inv(s*eye(size(A)) - (A-B*K - L*C)) * L));
G = simplify(K*inv(s*eye(size(A)) - (A-B*K-L*C))*L);
H = simplify(C*inv(s*eye(size(A)) - A) * B);

%% Stability
stability = true;
tau = 0; %input('tau: ');

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