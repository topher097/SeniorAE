clear, clc
%% Insert provided data here
A = [-0.7 0.3 -0.8; -0.5 0.1 -0.3; 0.8 0.4 -0.9];
B = [-0.5; -0.6; 0.0];
C = [0.3 0.5 -0.8];
K1 = [2348.8 -1943.0 -24.6];
K2 = [16.8 -0.2 -17.8];
K3 = [-13.2 -4.8 -5.7];
K4 = [6.2 -22.4 -14.8];
K5 = [386.4 -314.8 59.4];
L1 = [-40.3; 580.1; 333.3];
L2 = [-10.9; 102.5; 63.7];
L3 = [-89.7; 1595.2; 938.5];
L4 = [16.7; -165.8; -95.7];
L5 = [-3.1; -1477.0; -928.4];

%% Calculations -- do not modify
F1=[A-B*K1 -B*K1;zeros(size(A)) A-L1*C];
F2=[A-B*K2 -B*K2;zeros(size(A)) A-L2*C];
F3=[A-B*K3 -B*K3;zeros(size(A)) A-L3*C];
F4=[A-B*K4 -B*K4;zeros(size(A)) A-L4*C];
F5=[A-B*K5 -B*K5;zeros(size(A)) A-L5*C];

% Stable if all real parts are negative
eig(F1)
eig(F2)
eig(F3)
eig(F4)
eig(F5)