iTime = pTime - .9*pTime
iOver = pOver - .9*pOver
for i = (1:100)
    iTime = iTime + .01;
    for j = (1:100)
       %disp(i);
       %disp(j);
        iOver = iOver + .001;
        w = pi/iTime;
        s = log(iOver)/iTime;
        p = [(s) + w*i, (s) - w*i];
        K = place(A,B,p);
        kRef = 1/(-C*inv(A-B*K)*B);
        Am = A - B*K;
        sys = ss(Am,B,C,D);
        ligma = stepinfo(sys);
        rTime = ligma.PeakTime
        rOver = ligma.Overshoot
        if abs(rTime - pTime) < .1
            if abs(rOver - pOver) < .1
                break
            end
        end
        clear ligma
        clear sys 
    end
end