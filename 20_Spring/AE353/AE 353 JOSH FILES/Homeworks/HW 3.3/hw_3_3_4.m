clear, clc
%% Insert provided data here:


%% Useful Relations
kref = -1/(C*(A-B*K)^-1*B);
G = [C 0];
E = [A-B*K -B*kInt ; G];
F1 = [B*kref ; -1];
F2 = [B ;0];
 
Am = E;
Bm = [F1 F2];
Cm = G;
um = [r; d];
I = eye(length(Am));
syms t real
%% Equations
z0 = [x0;0];
z = expm(Am*t)*z0+Am^-1*(expm(Am*t)-I)*Bm*um; %Only the (N-1) values
y = Cm*z
