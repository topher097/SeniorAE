clear, clc
%% Insert provided data here:
A = [-1.0 -3.0; 5.0 0.0];


%% Calculations:  Caution when copying, only copy values a(2, ..., n)
a = poly(A);
a = mat2str(a(2:length(a)))