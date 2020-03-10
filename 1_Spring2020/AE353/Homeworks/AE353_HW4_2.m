%% Problem 1
clc;
clear all;

p = [-4.0-3.0j -4.0+3.0j];

a = poly(p);
disp(a(2:end));
%% Problem 2
clc;
clear all;

A = [-1.0 -3.0 1.0 4.0 1.0; -2.0 3.0 -4.0 -4.0 5.0; -1.0 1.0 2.0 -4.0 5.0; -2.0 2.0 1.0 4.0 -1.0; 0.0 1.0 -1.0 -2.0 3.0];

a = poly(A);
disp(a(2:end));
%% Problem 3
clc;
clear all;

A = [0.4 0.1; 0.3 -0.9];
B = [0.4; -0.8];

a = -1.*poly(A);

n = size(a(1:end));
e = eye(n(1,2)-1);
t = cat(1, a(2:end), e);
Accf = t(1:n(1,2)-1,:);
Bccf = cat(1,ones(1,1),zeros(n(1,2)-2,1));

disp(mat2str(Accf, 8));
disp(mat2str(Bccf, 8));
%% Problem 4
clc;
clear all;

A = [1.0 -0.4 -0.9; 0.1 0.4 0.3; -0.2 -0.7 -1.0];
B = [-0.7; 0.2; 0.2];
F = [-14.1 17.0 -8.3; 18.5 -19.9 10.2; 61.2 -68.1 34.4];
G = [1.1; -2.0; -6.0];

a = -1.*poly(A);

n = size(a(1:end));
e = eye(n(1,2)-1);
t = cat(1, a(2:end), e);
Accf = t(1:n(1,2)-1,:);
Bccf = cat(1,ones(1,1),zeros(n(1,2)-2,1));

W1 = ctrb(A, B);
W2 = ctrb(F, G);

V = W1*inv(W2);

disp(mat2str(V, 4));
%% Problem 5
clc;
clear all;

A = [-4.0 4.0 4.0 -3.0; 1.0 0.0 0.0 0.0; 0.0 1.0 0.0 0.0; 0.0 0.0 1.0 0.0];
B = [1.0; 0.0; 0.0; 0.0];
r = [21.0 180.0 846.0 1904.0];

a = poly(A);

Kccf = r - a(2:end);
disp(mat2str(Kccf, 4));
%% Problem 6
clc;
clear all;

A = [0.8 0.6 0.8; 0.7 -0.1 0.3; -0.9 0.0 0.1];
B = [0.1; 0.5; -0.8];
F = [1.9 -2.6 -1.6; 2.6 -2.3 -1.7; -2.5 1.4 1.2];
G = [-0.7; -0.1; -0.4];
V = [-1.0 2.0 1.0; 0.0 -1.0 -1.0; 2.0 -2.0 -1.0];
L = [5.0 1.0 -1.0];


K = L*inv(V);
disp(mat2str(K, 4));
%% Problem 7
clc;
clear all;

A = [-0.4 -0.1 -0.4 0.8; -0.1 1.0 0.1 -1.0; 0.9 -0.5 0.1 -0.7; -0.9 -0.7 -0.2 -0.1];
B = [0.4; 0.8; -0.1; 0.0];
p = [-6.0+0.0j -10.0+4.0j -10.0-4.0j -8.0+0.0j];

K = acker(A, B, p);
r = poly(p);
r = r(2:end);
a = poly(A);
a = a(2:end);

q = size(a(1:end));
e = eye(q(1,2));
t = cat(1, -1.*a, e);
Accf = t(1:q(1,2),:);
Bccf = cat(1,ones(1,1),zeros(q(1,2)-1,1));

Kccf = r - a;

W1 = ctrb(A, B);
W2 = ctrb(Accf, Bccf);
V = W1*inv(W2); 

K = Kccf*inv(V);

disp(mat2str(r, 5));
disp(mat2str(a, 5));
disp(mat2str(Accf, 5));
disp(mat2str(Bccf, 5));
disp(mat2str(Kccf, 5));
disp(mat2str(V, 5));
disp(mat2str(K, 5));




