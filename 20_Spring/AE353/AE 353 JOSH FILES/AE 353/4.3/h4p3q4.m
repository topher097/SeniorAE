u = [-1347.1673137; 2583.797265; -1241.37874154]
F = expm(A*h)
G = inv(A)*(expm(A*h)-eye(length(A)))*B

Am = ctrb(F,G)
Bm = inv(Am)*(xn-(expm(A*h))*x0)
mat2str(Bm)
diff = Bm - u;
