clear, clc

syms s

A = [0 1; -3 4];
B = [0; 3];
C = [1 0];
K = [6 4];
L = [10; 46];

kRef = inv(-C*inv(A-B*K)*B);

F = simplify((K*inv(s*eye(size(A)) - (A-B*K-L*C))*B*kRef - kRef) / (-K*inv(s*eye(size(A)) - (A-B*K-L*C))*L));
G = simplify(K*inv(s*eye(size(A)) - (A-B*K-L*C))*L);
H = simplify(C*inv(s*eye(size(A)) - A)*B);

tau = 0;
stability = true;

while stability == true
    tD = (2 - s*tau) / (2 + s*tau);
    T = simplify((F*G*H*tD) / (1 + H*G*tD));
    
    [N,D] = numden(T); stab = roots(double(flip(coeffs(D))));
    
    for i=1:length(stab)
        if stab(i) > 0
            tau
            stability = false;
            break
        else
            tau = tau+0.00001;
        end
    end
end