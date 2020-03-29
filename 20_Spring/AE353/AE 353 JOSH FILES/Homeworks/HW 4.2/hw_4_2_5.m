clear, clc
%% Insert provided data here:
A = [-5.0 -4.0 5.0; 1.0 0.0 0.0; 0.0 1.0 0.0];
B = [1.0; 0.0; 0.0];
r = [23.0 176.0 348.0];

%% Calculations: Do not edit
a = poly(A);
a = a(2:length(a));
c = eye(length(a));
d = zeros(length(a)-1, 1);

Accf = [-a; c];
Accf(length(Accf),:) = [];
Bccf = [1; d];

W = ctrb(A, B);
Wccf = ctrb(Accf, Bccf);

Kccf = [r - a];
K = mat2str(Kccf*Wccf*inv(W))