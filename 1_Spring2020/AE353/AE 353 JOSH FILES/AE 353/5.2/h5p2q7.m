clear
A = [0.00 1.00; 0.00 0.00];
B = [0.00; 1.00];
C = [1.00 0.00];
x2Max = 0.33;

found = 0
for i = 1:0.001:50
    m = i
    Q = [1 0; 0 m];
    R = [1];

    x0 = [0;0];
    K = lqr(A,B,Q,R);
    kRef = -1/(C*inv(A-B*K)*B);
    r = 1;
    
    t = 0:0.1:10;
    y = zeros(1,length(t));
    for j = 1:length(t)
        x = expm((A-B*K)*t(j))*x0 + inv(A-B*K)*(expm((A-B*K)*t(j)) - eye(size(A)))*B*kRef;
        if x(2) > x2Max
            % not allowed
            %disp('INVALID- TRY ANOTHER NUMBER')
            found = 0;
            break    % end program when x2 is out of bounds
        end
        y(j) = C*x;
        found = 1;
    end
    if found == 1
        break;
    end
end

info = stepinfo(y,t,'SettlingTimeThreshold',0.05);
info.SettlingTime
