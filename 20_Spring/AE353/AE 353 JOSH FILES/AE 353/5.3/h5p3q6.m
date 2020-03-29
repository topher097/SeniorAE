Am = [A zeros(2,1);C 0]; 
Bm = [B;0]; 

kss = lqr(Am,Bm,eye(3),eye(1)); 
K = kss(1:2); 
kint = kss(3); 
kref = 1/(-C*inv(A-B*K)*B);
mat2str(K)
mat2str(kint)
mat2str(kref)