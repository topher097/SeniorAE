clear, clc
%% Provided Data:
A = [0 1; -5 2];
B = [0; 1];
C = [1 0];
K = [-2 6];
L = [12; 60];

%% Block Diagrams
kRef = inv(-C*inv(A-B*K)*B);
syms s

F = simplify((K*inv(s*eye(size(A)) - (A-B*K-L*C))*B*kRef - kRef) / (-K*inv(s*eye(size(A)) - (A-B*K-L*C))*L));
G = simplify(K*inv(s*eye(size(A)) - (A-B*K-L*C))*L);
H = simplify(C*inv(s*eye(size(A))-A)*B);

%% Tau Test
stability = true;
tau = 0;

while stability == true
    tD = (2-s*tau) / (2+s*tau);
    T = simplify((-F*G*H*tD) / (1 + G*H*tD));
    
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
