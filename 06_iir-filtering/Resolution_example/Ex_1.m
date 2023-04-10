clc
close all
clear

fs = 10000;
tf = 1;
t = linspace(0, tf, tf*fs);
x = sin(2*pi*100*t);

snr = 15;
x_n = awgn(x, snr, 'measured');

figure
plot_fft(x_n, fs)
figure
plot(t, x_n)

%% Filter
lambda = 0.7;
% y[n] = lambda*y[n - 1] + (1 - lambda) x[n]
b = 1 - lambda;
a = [1, -lambda];
f_co_Hz = -log(lambda)*fs/pi
f_co_rad = -log(lambda)
f_co_rad_over_pi = -log(lambda)/pi


%% Filtering 0.75
lambda = 0.7;
% y[n] = lambda*y[n - 1] + (1 - lambda) x[n]
b = 1 - lambda;
a = [1, -lambda];

figure
zplane(b, a)
figure
freqz(b, a)

x_n_f = filter(b, a, x_n);

figure
plot_fft(x_n, fs)
plot_fft(x_n_f, fs)
figure
plot(t, [x_n; x_n_f])

%% Filtering 0.98
lambda = 0.98;
% y[n] = lambda*y[n - 1] + (1 - lambda) x[n]
b = 1 - lambda;
a = [1, -lambda];

figure
zplane(b, a)
figure
freqz(b, a)

x_n_f = filter(b, a, x_n);

figure
plot_fft(x_n, fs)
plot_fft(x_n_f, fs)
figure
plot(t, [x_n; x_n_f])

