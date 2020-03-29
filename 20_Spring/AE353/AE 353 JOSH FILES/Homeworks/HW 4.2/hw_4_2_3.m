clear,clc
%% Iput provided data here:
A = [0.7 -0.6 0.4 0.3; 0.2 -0.1 -0.3 -0.5; -0.4 -0.6 0.9 -0.6; 0.9 0.0 0.7 -0.8];
B = [0.5; -0.7; 0.4; -0.3];


%% Calculations: Do not change
a = poly(A);
a = a(2:end);
c = eye(length(a));
d = zeros(length(a)-1, 1);

Accf = vpa([-a; c], 5);
Accf(length(Accf),:) = [];
vpa(Accf,5)
Bccf = mat2str([1; d])