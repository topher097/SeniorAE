syms r d real
kRef = 1 / (-C * inv(A - B * K) * B);
Am = [A - B * K, -B * kInt; C, 0];
Bm = [B * kRef, B; -1, 0];
Cm = [C, 0];
um = [r; d];
E = Am
F1 = Bm(1:end,1)
F2 = Bm(1:end,2)
G = Cm
mat2str(E)
mat2str(F1)
mat2str(F2)
mat2str(G)