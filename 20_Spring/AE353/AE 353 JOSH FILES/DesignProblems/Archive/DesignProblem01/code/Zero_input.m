clear,clc

syms J1 J2 J3 w1 w2 w3 wd1 wd2 wd3 wEEE tau1 tau3 tEE

eqn1 = tau1 == J1*wd1 - (J2 - J3)*w2*w3;
eqn2 = 0 == J2*wd2 - (J3 - J1)*w3*w1;
eqn3 = tau3 == J3*wd3 - (J1 - J2)*w1*w2;

C1 = (J2-J3)/J1;
C2 = (J1-J3)/J2;
C3 = (J1-J2)/J3;

w1 = wEEE;
w2 = wEEE;
w3 = wEEE;
tau1 = tEE;
tau3 = tEE;

[A, B] = equationsToMatrix([eqn1, eqn2, eqn3], [tEE, wEEE]);
linsolve(A, B)