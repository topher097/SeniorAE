kRef = 1 / (-C * inv(A - B * K) * B);
Am = [A - B * K, -B * kInt; C, 0];
Bm = [B * kRef, B; -1, 0];
Cm = [C, 0];
um = [r; d];
t = t1-t0;
%x0 = [z(1); zdot(1)];
v0 = 0;
xm0 = [x0; v0];
xm = zeros(3, length(t));

x_t = expm(Am * t) * xm0 + inv(Am) * (expm(Am * t) - eye(size(Am))) * Bm * um
y_t = Cm * x_t
v_t = x_t(end)
x_t = x_t(1:end-1)
mat2str(x_t)
mat2str(v_t)
mat2str(y_t)
