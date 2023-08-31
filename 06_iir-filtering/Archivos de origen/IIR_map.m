close all
clear
clc

figure('color', 'white', 'PaperSize', [6 4])
set(gcf, 'PaperPosition', [0 0 6 4]);
axis equal;
subplot(1,2,1)
pzmap(tf([649.8^2], [1 649.8*sqrt(2) 649.8^2]))
xlabel 'eje real'
ylabel 'eje imaginario'
title 'Analógico'
subplot(1,2,2)
zplane([.067 .135 .067], [1 -1.143 0.413])
xlabel 'eje real'
ylabel 'eje imaginario'
title 'Digital'


figure('color', 'white', 'PaperSize', [6 4])
set(gcf, 'PaperPosition', [0 0 6 4]);
axis equal;
bode(tf([649.8^2], [1 649.8*sqrt(2) 649.8^2]))
hold on
bode(tf([.067 .135 .067], [1 -1.143 0.413], .001))
legend('analógico', 'digital')
title 'Diagrama de Bode'
