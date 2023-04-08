

clc
clear
close all


path = 'C:\Users\joses\Mi unidad\Docencia\fing\Mecatronica\Control y Sistemas\Repo\control\05_fir-filtering\files\'
load([path 'Tchaikovsky.mat'])

my_signal = signal(:, 1);
% sound(my_signal, Fs)


% Add noise
SNR = 10 % 50
my_signal_n = awgn(my_signal, SNR, 'measured');
20*log10(rms(my_signal)/rms(my_signal_n - my_signal))
% sound(my_signal_n, Fs)


% Moving average filter
f_co = 1000 % 11025
F_CO = f_co / Fs
N_max = round(sqrt(((0.885894^2)/(F_CO^2)) - 1))

windowSize = N_max;  
b = (1/windowSize)*ones(1,windowSize);
a = 1;
filtered_signal = filter(b, a, my_signal_n);
filtered_signal = filtered_signal * (rms(my_signal_n)/rms(filtered_signal));


figure
plot([my_signal, my_signal_n, filtered_signal])
legend('original', 'noisy', 'filtered')


sound([my_signal; my_signal_n; filtered_signal], Fs)
