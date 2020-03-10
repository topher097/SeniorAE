clear , clc
%% Insert provided data here:
A = [-0.50 -0.30 -0.50; -0.50 0.30 0.60; 0.50 -0.60 -0.40];
B = [-0.80; 0.80; 0.20];
C = [0.90 -0.30 0.10];
D = [0.00];
K = [-26.53 -17.75 -9.55];
kInt = -18.94;
t0 = 0.80;
t1 = 1.00;
x0 = [-0.30; 0.00; 1.00];
r = 0.90;
d = 0.10;

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

%% Equations
z0 = [x0;0];
 
z = expm(Am*(t1-t0))*z0+Am^-1*(expm(Am*(t1-t0))-I)*Bm*um;
for i=1:(length(z)-1)
    x(:,i) = z(i);
end
x = mat2str(x.')
v = mat2str(z(length(z)))
y = Cm*z