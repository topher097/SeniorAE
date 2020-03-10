function kRef = kRef(A,B,C,K)
%   kRef function helps find the kRef part of the input equation:
%   u = -K * x + kRef * r + d.  Enter in your matrices: A, B, C, K
%   separated by commas.
    kRef = inv(-C*inv(A - B*K)*B);
    kRef; 
end