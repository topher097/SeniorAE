function Accf = Accf(A)
   a = poly(A);
   a = a(2:length(a));
   c = eye(length(a));
   d = zeros(length(a) - 1, 1);
   
   Accf = [-a; c];
   Accf(length(Accf),:) = [];
end