%% 8.3.1
clear; clc;
syms s
A = [0 1; -5 1];
B = [0; 3];
C = [1 0];
K = [4 1];
L = [5; 29];
D = 0;
kref = 1/(-C*inv(A-B*K)*B);
H = simplify(C*inv(s*eye(size(A))-A)*B+D) 
G = simplify(K*inv(s*eye(size(A))-(A-B*K-L*C))*L) 
F = simplify((K*inv(s*eye(size(A))-(A-B*K-L*C))*B*kref-kref)/(-K*inv(s*eye(size(A))-(A-B*K-L*C))*L))


%% 8.3.2
clear; clc;
syms s
F = 4
G = 2*s + 3
H = -1/(s^2+8)
T = simplify(F/(1+H*G))

%% 8.3.3
clear; clc;
syms s
F = 4
G = 2*s + 3 + (6/s)
H = (-3*s+2)/(s^2+9)
T = simplify(1/(1+G*H))

%% 8.3.5
clear; clc;
syms s
F = 3
G = 5*s + 1 + (0/s)
H = (s-4)/(s^2-15)
T = simplify((-H*G)/(1+G*H))

%% 8.3.6
clear; clc;
syms s
F = 2
G = 1*s + 1 + (5/s)
H = (3*s + 1)/(s^2 - 20)
T = simplify((-G)/(1+G*H))