Ac1 = A - L*C;
Ac2 = Ac1';
Ac3 = A' - C'*L';

e1 = eig(Ac1)';
e2 = eig(Ac2)';
e3 = eig(Ac3)';

disp(mat2str(e1))
disp(mat2str(e2))
disp(mat2str(e3))