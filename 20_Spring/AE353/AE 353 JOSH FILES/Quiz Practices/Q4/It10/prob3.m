clear, clc

L = 3;
w = [0.0100000000 0.0120679264 0.0145634848 0.0175751062 0.0212095089 0.0255954792 0.0308884360 0.0372759372 0.0449843267 0.0542867544 0.0655128557 0.0790604321 0.0954095476 0.1151395399 0.1389495494 0.1676832937 0.2023589648 0.2442053095 0.2947051703 0.3556480306 0.4291934260 0.5179474679 0.6250551925 0.7543120063 0.9102981780 1.0985411420 1.3257113656 1.5998587196 1.9306977289 2.3299518105 2.8117686980 3.3932217719 4.0949150624 4.9417133613 5.9636233166 7.1968567300 8.6851137375 10.4811313415 12.6485521686 15.2641796718 18.4206996933 22.2299648253 26.8269579528 32.3745754282 39.0693993705 47.1486636346 56.8986602902 68.6648845004 82.8642772855 100.0000000000];
mag = [8.7165649865 8.7175565784 8.7193378131 8.7217871459 8.7251579579 8.7302829733 8.7378706603 8.7486976197 8.7645367423 8.7877065752 8.8211805213 8.8706310940 8.9425122690 9.0474106175 9.2018756681 9.4287343636 9.7619308081 10.2505552017 10.9549259935 11.9085834660 12.9420682076 13.2476970564 11.7110742911 8.9918605881 6.5706719704 4.8464450256 3.6683635077 2.8479965821 2.2564180533 1.8147338070 1.4745307630 1.2063644723 0.9915257614 0.8173914797 0.6749550123 0.5578150344 0.4616831068 0.3822630934 0.3163508516 0.2621383199 0.2170319934 0.1797343271 0.1489906655 0.1234198909 0.1024019127 0.0847747675 0.0701610900 0.0580799079 0.0483267151 0.0401090400];
ang = [-3.1389438301 -3.1381540307 -3.1374508152 -3.1366571452 -3.1356013532 -3.1344531300 -3.1329107934 -3.1308726053 -3.1286081175 -3.1258479994 -3.1222288409 -3.1174369170 -3.1114239151 -3.1030192758 -3.0912522551 -3.0742482661 -3.0484176698 -3.0074581566 -2.9401785811 -2.8259587892 -2.6332193660 -2.3373051044 -1.9892822411 -1.7084294009 -1.5391710048 -1.4523309924 -1.4143982622 -1.4043609975 -1.4089203743 -1.4212718903 -1.4372870645 -1.4539211438 -1.4702433556 -1.4853176248 -1.4985449486 -1.5102798810 -1.5200724104 -1.5284169986 -1.5355364362 -1.5414823215 -1.5465428632 -1.5506663097 -1.5540855244 -1.5569002727 -1.5593333317 -1.5612396532 -1.5628151972 -1.5643494963 -1.5654142375 -1.5664077877];

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