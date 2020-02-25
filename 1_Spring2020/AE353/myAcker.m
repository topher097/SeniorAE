function K = myAcker(A, B, p)
% A and B define a state-space system
% p is a list of eigenvalue locations
% K is a gain matrix

% Check the size of A, B, and p
if size(A, 1) ~= size(A, 2)
    error('A is not square');
end
n = size(A, 1);
if size(B) ~= [n, 1]
    error('B has the wrong size');
end
if length(p) ~= n
    error('p has the wrong length');
end

% Find the coefficients of the char. poly. with roots at p
r = poly([-2 -5]);

% Find the coefficients of the char. poly. of A
a = poly(A);

% Find the equivalent system in controllable canonical form
n = size(a(1:end));
e = eye(n(1,2)-1);
t = cat(1, a(2:end), e);
Accf = t(1:n(1,2)-1,:);
Bccf = cat(1,ones(1,1),zeros(n(1,2)-1,1));

% Find state feedback for the system in controllable canonical form
Kccf = r - a

% Find the coordinate transformation between equivalent systems
% W = ...
% Wccf = ...
% inverse_of_V = ...

% Find equivalent state feedback
K = []

end