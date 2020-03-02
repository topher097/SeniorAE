%% Problem 1
clc;
clear all;

A = [-1.00 -1.00 1.00; 0.00 1.00 0.00; 0.00 -1.00 1.00];
B = [1.00 -1.00; 1.00 0.00; 2.00 -1.00];
p = [-1.00 -5.00 -2.00];
p1 = [-2 -5 -1];

K1 = place(A, B, p);
K2 = -0.01 + place(A, B, p1);
disp(mat2str(K1, 8));
disp(mat2str(K2, 8));


%% Problem 2
clc;
clear all;

A1 = [-1.6 -9.0 -0.6 -11.7; -2.7 -20.6 -2.1 -28.7; -9.9 -65.8 -5.8 -89.3; 2.7 20.6 2.1 28.7];
B1 = [0.2; 0.7; 2.0; -0.7];
A2 = [4.9 -4.7 -1.4; 21.8 -21.7 -6.5; -55.6 55.7 16.7];
B2 = [0.0; -0.2; 0.7];
A3 = [0.5 -2.4; 0.0 0.0];
B3 = [-0.1; 0.0];
A4 = [6.2 31.4 -15.1 -5.3; 15.8 78.6 -35.5 -12.7; -87.7 -436.7 197.8 70.7; 350.8 1746.8 -791.2 -282.8];
B4 = [-0.3; -0.6; 3.4; -13.6];
A5 = [-22.9 -63.3 15.2 9.6; 114.7 328.9 -79.4 -49.6; 340.3 968.6 -233.6 -146.2; 164.5 486.0 -117.8 -73.0];
B5 = [2.2; -11.1; -32.8; -16.0];

W1 = ctrb(A1,B1)
W2 = ctrb(A2,B2)
W3 = ctrb(A3,B3)
W4 = ctrb(A4,B4)
W5 = ctrb(A5,B5)

if rank(W1) == size(A1)
    disp('W1 yes')
else
    disp('W1 no')
end 

if rank(W2) == size(A2)
    disp('W2 yes')
else 
    disp('W2 no')
end 

if rank(W3) == size(A3)
    disp('W3 yes')
else 
    disp('W3 no')
end 

if rank(W4) == size(A4)
    disp('W4 yes')
else 
    disp('W4 no')
end

if rank(W5) == size(A5)
    disp('W5 yes')
else 
    disp('W5 no')
end

%% Problem 3
clc;
clear all;



%% Problem 4
clc;
clear all;


