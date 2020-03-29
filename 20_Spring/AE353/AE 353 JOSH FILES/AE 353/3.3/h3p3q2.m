syms r d
Am1 = [A - B * K1, -B * kInt1; C, 0];
Am2 = [A - B * K2, -B * kInt2; C, 0];
Am3 = [A - B * K3, -B * kInt3; C, 0];
Am4 = [A - B * K4, -B * kInt4; C, 0];
Am5 = [A - B * K5, -B * kInt5; C, 0];
e1 = eig(Am1)
e2 = eig(Am2)
e3 = eig(Am3)
e4 = eig(Am4)
e5 = eig(Am5)