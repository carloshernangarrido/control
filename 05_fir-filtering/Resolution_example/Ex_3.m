

clc
clear
close all


path = 'C:\Users\joses\Mi unidad\Docencia\fing\Mecatronica\Control y Sistemas\Repo\control\05_fir-filtering\files\'
load([path 'Tchaikovsky.mat'])

signal = signal(:, 1);

Hd = fir_kaiser_300_3400;
b = Hd.Numerator;
a = 1;

fir_output = filter(b, a, signal);

[f, dft_mag_signal, dft_phase, dft, NFFT] = my_dft(signal, Fs);
[f, dft_mag_fir, dft_phase, dft, NFFT] = my_dft(fir_output, Fs);
figure
hold on
plot(f, dft_mag_signal, 'LineWidth', 2)
plot(f, dft_mag_fir, 'LineWidth', 2)
plot(f, dft_mag_fir./dft_mag_signal)

