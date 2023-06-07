clear
clc
close all

lambda = 0.6

N = 10;
ns = 1:1:N;

x = zeros(length(ns),1);
x(1) = 1;
y = zeros(length(ns),1);
for n = ns
    if n == 1
        y(n) = (1-lambda)*x(n);
    else
        y(n) = (1-lambda)*x(n) + lambda*y(n-1);
    end
end

figure('color', 'white', 'PaperSize', [6 3])
set(gcf, 'PaperPosition', [0 0 6 3]);
axis equal;
subplot(1,2,1)
hold on
% stem(ns-1, (1-lambda)*(lambda.^(ns-1)), ...
%     'displayname', 'h[n]', 'marker', '*', 'linewidth', 2,...
%     'markersize', 10)
stem(ns-1, x, 'displayname', 'x[n]', 'marker', 'x', ...
    'linewidth', 2, 'markersize', 10)
stem(ns-1, y, 'displayname', 'y[n]', 'marker', 'o', ...
    'linewidth', 2, 'markersize', 10)
legend
xlabel 'n'

%%
Ts = 1e-3;
fs = 1/Ts;
Omega_co = (1-lambda)*2*pi*fs/2
z = tf('z', Ts);
H = (1-lambda) / (1 - lambda*z^(-1))
subplot(1,2,2)
% figure('color', 'white')
zplane(H.Numerator{1,1}, H.Denominator{1,1})

xlabel 'eje real'
ylabel 'eje imaginario'

%%
figure('color', 'white', 'PaperSize', [6 5])
set(gcf, 'PaperPosition', [0 0 6 5]);
axis equal;
bodeplot(H)
print -r500 -dpdf