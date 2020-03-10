% clear, clc  WRONG WRONG WRONG WRONG 

L = 2;
w = [0.0100000000 0.0123886292 0.0153478134 0.0190138370 0.0235555378 0.0291820824 0.0361525999 0.0447881156 0.0554863359 0.0687399643 0.0851593932 0.1055008148 0.1307010480 0.1619206824 0.2005975301 0.2485128427 0.3078733470 0.3814128748 0.4725182694 0.5853853648 0.7252122247 0.8984385372 1.1130421933 1.3789067061 1.7082763938 2.1163202882 2.6218307404 3.2480888972 4.0239369086 4.9851062446 6.1758632986 7.6510480643 9.4785997765 11.7426858345 14.5475781085 18.0224551525 22.3273514878 27.6605279492 34.2676025343 42.4528622739 52.5932770886 65.1558610364 80.7191805189 100.0000000000];
mag = [1.7167508551 1.7164814205 1.7164945384 1.7166095797 1.7163887993 1.7161796690 1.7156519796 1.7153801269 1.7145038956 1.7134155510 1.7119826792 1.7091879832 1.7050859838 1.6991214251 1.6900934830 1.6761888071 1.6555538291 1.6252062314 1.5813872961 1.5202545803 1.4372689237 1.3316580220 1.2049382170 1.0625406867 0.9150699117 0.7715752332 0.6408652351 0.5263007808 0.4291501518 0.3485202978 0.2824224078 0.2284622795 0.1848311925 0.1492414264 0.1206879819 0.0972751797 0.0784836768 0.0634447330 0.0509850153 0.0412267206 0.0333896640 0.0270234980 0.0217649152 0.0174876694];
ang = [-0.0093119816 -0.0113205737 -0.0142208307 -0.0172916960 -0.0218514294 -0.0267972626 -0.0332899519 -0.0413517525 -0.0510627517 -0.0633478207 -0.0783747288 -0.0969626628 -0.1198717186 -0.1482107247 -0.1830921521 -0.2257055304 -0.2777656197 -0.3400181588 -0.4143377374 -0.5009970956 -0.5992298664 -0.7067699243 -0.8197359531 -0.9322514876 -1.0389619124 -1.1344023861 -1.2165409036 -1.2852738990 -1.3408259678 -1.3858140481 -1.4218585899 -1.4510682875 -1.4742375154 -1.4929144645 -1.5080231015 -1.5202357778 -1.5301507529 -1.5379454165 -1.5440692706 -1.5493198617 -1.5533466449 -1.5568678827 -1.5593915347 -1.5615331375];

s = j*w;
H = mag.*exp(j*ang);
P = [];

for i=1:length(H)
    t = [];
    
    for j=1:L
        t = [t, s(i)^(L-j)];
    end
    for j=1:L
        t = [t, -s(i)^(L-j)*H(i)];
    end
    P = [P; t];
end
r = [];
for i=1:length(H)
    r = [r; s(i)^L*H(i)];
end

P = [real(P); imag(P)];
r = [real(r); imag(r)];

q = inv(P'*P)*P'*r;

b = [];
for i=1:L
    b = [b, q(i)];
end

a = [];
for i=1+L:2*L
    a = [a, q(i)];
end

b = mat2str(b)
a = mat2str(a)