clear, clc
%% Insert provided data:
A = [-0.70 -0.90 -0.80 -0.80; 0.40 -0.30 -0.90 0.40; 0.20 -0.20 0.70 0.90; 0.30 -0.30 0.10 -0.90];
C = [0.50 0.40 0.50 -0.10];
L = [-95.20; -209.50; 288.40; 31.80];

%% Calculations -- do not modify:
eig1 = mat2str(eig(A-L*C)');
eig2 = mat2str(eig((A-L*C)')');
eig3 = mat2str(eig((A-L*C).')');

disp(eig1);
disp(eig2);
disp(eig3);
