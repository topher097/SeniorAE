clear, clc
L = 2;
w = [0.0100000000 0.0134596032 0.0181160919 0.0243835410 0.0328192787 0.0441734470 0.0594557071 0.0800250228 0.1077105056 0.1449740670 0.1951293423 0.2626363528 0.3534981105 0.4757944314 0.6404004271 0.8619535665 1.1601553017 1.5615230060 2.1017480113 2.8288694346 3.8075460212 5.1248058770 6.8977853794 9.2841454452 12.4960914129 16.8192432488 22.6380340952 30.4698957090 41.0112707055 55.1995432128 74.2963950759 100.0000000000];
mag = [1.0158388832 1.0159985190 1.0159866546 1.0160567203 1.0162906772 1.0164262224 1.0170144314 1.0179239546 1.0196066484 1.0228722784 1.0285426041 1.0387380000 1.0572637019 1.0913776170 1.1527641087 1.2606171076 1.4232881661 1.5079083708 1.2071962328 0.7866869894 0.5107041232 0.3462152931 0.2437088772 0.1754941267 0.1282530064 0.0941667278 0.0696583899 0.0516751217 0.0382240689 0.0283765931 0.0210099198 0.0155823487];
ang = [-3.1413170946 -3.1412037472 -3.1410708415 -3.1409652598 -3.1407640767 -3.1405973339 -3.1400236815 -3.1397057383 -3.1388420039 -3.1376350676 -3.1358289060 -3.1322632151 -3.1255283479 -3.1111902101 -3.0792756223 -3.0037566626 -2.8255661498 -2.4563360934 -1.9940895978 -1.7098700306 -1.5933283463 -1.5536825004 -1.5442061511 -1.5452669872 -1.5494375121 -1.5540429393 -1.5578733215 -1.5610473062 -1.5635678180 -1.5651002622 -1.5667158272 -1.5677617348];

s = j*w;
H = mag.*exp(j*ang);
P = [];
for i=1:length(H)
    t = [];
    for j=1:L
        t = [t,s(i)^(L-j)];
    end
    for j=1:L
        t = [t, -s(i)^(L-j)*H(i)];
    end
    P = [P;t];
end
r = [];
for i=1:length(H)
    r = [r;s(i)^L*H(i)];
end

P = [real(P); imag(P)];
r = [real(r); imag(r)];

q = inv(P'*P)*P'*r;
b = [];
for i=1:L
    b = [b,q(i)];
end
b = mat2str(b)
a = [];
for i=L+1:2*L
    a = [a,q(i)];
end
a = mat2str(a)