%% Quiz 3 Retake Retake
clc;
clear all;

%% Problem 1
clc;
clear all;
A1 = [-5.4 10.8; -2.5 5.0];
A2 = [-28.8 88.1 -55.9; -6.8 20.9 -13.1; 3.7 -11.1 7.4];
A3 = [-8.9 -19.0 -1.7 0.0; 3.8 7.9 1.2 0.0; 1.7 3.5 0.6 0.0; 1.8 1.7 5.0 0.0];
A4 = [4.7 -3.4 -6.8; 9.5 -7.6 -15.2; -1.6 1.5 3.0];
A5 = [-5.3 -24.9 14.3; -1.5 -7.1 4.1; -4.6 -21.7 12.5];
C1 = [-0.6 1.3];
C2 = [1.6 -5.4 2.5];
C3 = [0.6 1.8 -1.1 0.0];
C4 = [0.6 -0.5 -1.0];
C5 = [0.0 0.1 0.0];


% Choose whatever is a "large" number, anything basically zero is not it
Observable1 = det(obsv(A1, C1))
Observable2 = det(obsv(A2, C2))
Observable3 = det(obsv(A3, C3))
Observable4 = det(obsv(A4, C4))
Observable5 = det(obsv(A5, C5))

%% Problem 2
clc;
clear all;




%% Problem 3
clc;
clear all;

A = [0.30 -0.90; 0.80 -0.50];
B = [-0.20; -0.60];
C = [-0.70 -0.90];
K = [1.20 -6.10];
L = [-18.00; 7.10];

kRef = -1/(C*inv(A-B*K)*B);

F = [A-B*K -B*K; zeros(size(A)) A-L*C];
G = [B*kRef; zeros(length(B*kRef), 1)];
H = [C zeros(1, length(C))];

F = mat2str(F)
G = mat2str(G)
H = mat2str(H)



%% Problem 4
clc;
clear all;




%% Problem 5
clc;
clear all;

A = [0.40 -0.40; 0.40 0.50];
B = [-0.70; -0.70];
C = [-0.30 0.90];
p = [-8.29 -7.74];

L = mat2str(acker(A', C', p)',5)

%% Problem 6
clc;
clear all;

A = [0.1 0.3 0.5 0.8; 0.8 0.0 -0.6 -0.7; -0.3 -0.9 -0.2 0.3; -0.5 -0.2 -0.3 -0.6];
B = [0.4; -0.2; 0.2; 0.1];
C = [0.9 0.2 -0.7 0.6];
L1 = [3.7; 30.0; -15.3; -17.7];
L2 = [9469.6; -6569.5; 12591.2; 2687.3];
L3 = [316.4; -15.6; 189.5; -220.5];
L4 = [645.7; -205.5; 545.9; -234.4];
L5 = [363.6; -78.9; 279.4; -168.2];

% Stable if all real vals are negative
stab1 = eig(A-L1*C)
stab2 = eig(A-L2*C)
stab3 = eig(A-L3*C)
stab4 = eig(A-L4*C)
stab5 = eig(A-L5*C)
