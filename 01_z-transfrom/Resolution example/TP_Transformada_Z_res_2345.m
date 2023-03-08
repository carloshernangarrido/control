clc
clear
close all

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
oldparam = sympref('HeavisideAtOrigin',1);
syms n
x = heaviside(n)*(0.5)^n + heaviside(n)*(0.3)^n + heaviside(n)*(0.9)^n
X = ztrans(x)
pretty(X)
% ROC: |z| > 9/10

% Ej. 4.1
H = filt([1], [1, -.7]);
H
% Ej. 4.2
% x = dirac(n)
X = 1
Y = H * X
syms z
disp("response to impluse")
y = iztrans(1/(1-0.7*z^-1))
% Ej. 4.3
% x = heaviside(n)
X = filt([1], [1, -1])
Y = H * X
syms z
disp("response to step")
y = iztrans(1/(1 - 1.7*z^-1 + 0.7*z^-2))

% Using residuez
[r,p,k] = residuez([1], [1, -1.7, 0.7])

% Using filter
disp("response to impluse")
n = 0:11;
x_n = [0 0 0 1 0 0 0 0 0 0 0 0]
y_n = filter(cell2mat(H.numerator), cell2mat(H.denominator), x_n)
figure
hold on
plot(n, x_n, 'LineStyle', 'none', 'marker', 'o', 'color', 'blue')
plot(n, y_n, 'LineStyle', 'none', 'marker', 'o', 'color', 'red')

disp("response to step")
x_n = [0 0 0 1 1 1 1 1 1 1 1 1]
y_n = filter(cell2mat(H.numerator), cell2mat(H.denominator), x_n)
figure
hold on
plot(n, x_n, 'LineStyle', 'none', 'marker', 'o', 'color', 'blue')
plot(n, y_n, 'LineStyle', 'none', 'marker', 'o', 'color', 'red')


% Ej. 5
H = filt([1], [1, -0.5, -0.1, -0.2])
n = 0:100
x_n = ones(1, length(n));
y_1 = 1;
y_2 = 2;
y_3 = 3;

xi = [0]
yi = [1 2 3]
b = cell2mat(H.num)
a = cell2mat(H.den)
zi = filtic(b, a, yi, xi)

y_n = filter(b, a, x_n, zi);
figure
hold on
plot(n, x_n, 'LineStyle', 'none', 'marker', 'o', 'color', 'blue')
plot(n, y_n, 'LineStyle', 'none', 'marker', 'o', 'color', 'red')


figure
zplane(b, a)
hold on
% [r,p,k] = residuez(b, a)
% plot(p, '^r')
% all the poles inside the unit circle => stable

