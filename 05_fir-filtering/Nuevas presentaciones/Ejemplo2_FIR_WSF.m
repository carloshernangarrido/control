%% Se mide aceleraciones que se componen de dos componentes sinusoidales de
%% 1 y 2 Hz. Durante la medición hay fuerte ruido de línea que contamina la 
%% señal con otra componente de 50 Hz. La aceleración medida será sub-
%% muestreada de 200 Hz a 30 Hz, con lo cual la componente de ruido de 
%% línea debería desaparecer (15 < 50). Sin embargo, aún está presente.
%% Arregle la sección Filtering de manera tal que se maximice la SNR.

clc
close all
clear

ti = 0 % s
tf = 2 % s
fs = 200 % Hz
t = ti:1/fs:tf;

f_signal_1 = 1 % Hz
f_signal_2 = 2 % Hz
f_noise = 50 % Hz
actual_accel = sin(2*pi*f_signal_1*t) +  sin(2*pi*f_signal_2*t);
noise = 2*sin(2*pi*f_noise*t);
measured_accel = actual_accel + noise;


%% Filtering
% f_co = 25 % 2.5
% F_CO = f_co / fs
% Omega_co = F_CO*pi/0.5
% N = round(pi/Omega_co)
% b = (1/N)*ones(1, N);

mifiltro = filtro_hamming_100;
% mifiltro = filtro_hamming_10;


b = mifiltro.Numerator;
a = 1;
filtered_measured_accel = filter(b, a, measured_accel);

figure
bode(filt(b, a, 1/fs))
figure
zplane(b, a)

%% Subsampling
fs_new = 30 % Hz
subsampled_filtered_measured_accel = filtered_measured_accel(1:round(fs/fs_new):end);
subsampled_t = t(1:round(fs/fs_new):end);


X = abs(fft(measured_accel));
X_filt = abs(fft(filtered_measured_accel));
figure
hold on
plot(linspace(0, fs/2, round(length(X)/2)), X(1:round(length(X)/2)), 'linewidth', 2);
plot(linspace(0, fs/2, round(length(X_filt)/2)), X_filt(1:round(length(X_filt)/2)), 'linewidth', 2);
legend('measured accel', 'filtered accel')
xlabel('f (Hz)')


figure
hold on
plot(t, [measured_accel; actual_accel], 'linewidth', 2)
plot(subsampled_t, subsampled_filtered_measured_accel, 'linewidth', 2)
xlabel('t (s)')
legend('measured accel', 'actual accel', 'subsampled measured accel')


%% Evaluation
subsampled_actual_accel = actual_accel(1:round(fs/fs_new):end);
SNR = 20*log10(rms(subsampled_actual_accel)/rms(subsampled_filtered_measured_accel - subsampled_actual_accel))

if SNR < 10
    disp(['Nota Ej 1 = 4'])
elseif SNR < 13
    disp(['Nota Ej 1 = 5'])
elseif SNR < 16
    disp(['Nota Ej 1 = 6'])
elseif SNR < 19
    disp(['Nota Ej 1 = 7'])
elseif SNR < 22
    disp(['Nota Ej 1 = 8'])
else
    disp(['Nota Ej 1 = 9'])
end