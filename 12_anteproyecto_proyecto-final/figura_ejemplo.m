% Version: 002
% Date:    2020/03/02
% Author:  Rodrigo Gonzalez <rodrigo.gonzalez@ingenieria.uncuyo.edu.ar>
% URL:     https://github.com/rodralez/control 

clear
close all
clc
matlabrc

%% SIGNALS

t = 0:0.01:2; 	% vector time

signal_1 = sin(2* pi* 1 * t);

signal_2 = sin(2* pi* 1 * t + pi/4);

signal_3 = sin(2* pi* 1 * t + pi/2);

%% PLOT OPTIONS

font_tick  = 30;
font_label = 35;
font_title = 45;

line_wd = 2.5;

%% FIGURE

figure;

h = plot(t, signal_1, 'o-', 'LineWidth', line_wd);
hold on
plot(t, signal_2, 'o-', 'LineWidth', line_wd);
plot(t, signal_3, 'o-', 'LineWidth', line_wd);

grid on

legend('Acel X', 'Acel Y', 'Acel Z')
% axis tight
axis([0 1 -1.25 1.25 ])

% tl = title('Aceleraciones');
xl = xlabel('Tiempo [s]');
yl = ylabel('Amplitud [m/s^2]');

set(h,'Linewidth', line_wd);
set(gca, 'YTickMode', 'auto', 'FontSize', font_tick);

% set(tl,'FontSize', font_title);
set(xl,'FontSize', font_label);
set(yl,'FontSize', font_label);

% Hacer full screen de la figura antes de guardarla
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
saveas(gcf,'aceleraciones.png')

%% SAVE

% print (fig, 'acc_rmse', '-dpng',  '-bestfit')
