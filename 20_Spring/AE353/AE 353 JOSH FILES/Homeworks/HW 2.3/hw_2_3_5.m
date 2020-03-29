clear, clc
%% Insert provided data here:


%% Calculation (do not edit)
xd1 = eig((A - B*K1))
xd2 = eig((A - B*K2))
xd3 = eig((A - B*K3))
xd4 = eig((A - B*K4))
xd5 = eig((A - B*K5))

% If all the eigenvalues of A have a negative real part, stable
% If one is positive, unstable