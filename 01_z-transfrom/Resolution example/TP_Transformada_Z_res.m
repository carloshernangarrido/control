% Exercise 1

clc
clear

poles = [1/3]
zeros = [0]

[num, den] = zp2tf(zeros, poles, 1)

figure
zplane(zeros, poles)

figure
freqz(num, den)