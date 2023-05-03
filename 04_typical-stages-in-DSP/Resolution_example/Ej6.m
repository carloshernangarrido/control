clc
clear
close all

% Ej. 6.1.
q1 = quantizer('fixed','floor','saturate',[32 0]); %[wordlength fractionlength]
q2 = quantizer('fixed','floor','saturate',[32 8]);
q3 = quantizer('fixed','floor','saturate',[32 16]);


% Ej. 6.2.
u = linspace(-15, 15, 1000);

% Ej. 6.3
y1 = quantize(q1, u);
y2 = quantize(q2, u);
y3 = quantize(q3, u);


figure
hold on
plot(u, u, 'linewidth', 3)
plot(u, y1, 'linewidth', 2)
plot(u, y2, 'linewidth', 2)
plot(u, y3, 'linewidth', 2)
legend('u', 'y1', 'y2', 'y3')

% Ej. 6.4
r1 = rms(u-y1)
r2 = rms(u-y2)
r3 = rms(u-y3)

% Ej. 6.5
% There is an optimum representation for each span range.