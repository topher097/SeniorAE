%% HW 8.2
clc;
clear all;
close all;

%%
% Define numerator a*s^2 + b*s + c = [a b c], b*s + c = [b c], etc...  
num = [2000 30000];
% Define denominator a*s^2 + b*s + c = [a b c], b*s + c = [b c], etc...
den = [3 30000];
% Define transer function
H = tf(num, den); 
% Plot bode diagram
bode(H)