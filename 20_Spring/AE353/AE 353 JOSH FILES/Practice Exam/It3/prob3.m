clear, clc

A = [0.10000000 -0.50000000 -0.50000000; 0.70000000 0.60000000 0.00000000; 0.40000000 -0.10000000 0.10000000];
B = [0.80000000; -0.60000000; -0.60000000];
C = [-0.60000000 -0.20000000 -0.10000000];
D = [0.00000000];
K = [5.60000000 4.70000000 -3.30000000];
kRef = [0.10000000];

F = (-C* (A - B*K)^-1 * B * kRef - 1)