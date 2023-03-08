clc
clear

% Ej. 2.4
n  = [0,  1,  2,  3]
x1 = [1,  1,  3]
x2 = [1,  0,  3]
conv(x1, x2)

% Ej. 2.5
X1 = filt(x1, [1])
X2 = filt(x2, [1])
X = X1*X2

% Ej. 3
syms n
x = heaviside(n)*(0.5)^n + heaviside(n)*(0.3)^n + heaviside(n)*(0.9)^n
X = ztrans(x)
pretty(X)
% ROC: |z| > 10/9
