syms t real
kRef = 1 / (-C * inv(A - B * K) * B);
Am = [A - B * K, -B * kInt; C, 0];
Bm = [B * kRef, B; -1, 0];
Cm = [C, 0];
um = [r; d];

v0 = 0
xm0 = [x0; v0];
x_t = expm(Am * t) * xm0 + inv(Am) * (expm(Am * t) - eye(size(Am))) * Bm * um
y_t = (Cm * x_t)