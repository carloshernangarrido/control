% fir_c_online: script to compare FIR filters implemented in C and MATLAB
% languages.
%
% Version: 002
% Date:    2021/11/01
% Author:  Rodrigo Gonzalez <rodralez@frm.utn.edu.ar>
% URL:     https://github.com/rodralez/control

clc
close all
clear

%% PARAMETERS

Fn1 = 300;   % Signal 1 frequency
Fn2 = 600;   % Signal 2 frequency
Fn3 = 50 ;   % Signal 3 frequency, interference
Fs = 10000;  % Sampling frequency

%% INPUT SIGNAL

dt = 1/Fs;
t = (0:dt:dt*1000)';

adc_signal = 0.01*sin(2 * pi * Fn1 * t) + sin(2 * pi * Fn2 * t) + 0.25 * sin(2 * pi * Fn3 * t);

% Input signal must be in float, not double
adc_signal = adc_signal/1; % to avoid saturation
adc_signal_f = single(adc_signal);

frac_n = 15;
adc_signal_f_int16 = int16((2^frac_n)*adc_signal);
figure
plot(adc_signal_f_int16)

%% C FIR FILTERING

s = size(adc_signal_f);
M = max(s);

% fir_output = zeros(s); 
fir_output = zeros(s, 'int16'); 


for j = 1:M
    
   fir_output (j) = fir_wrapper_int16( adc_signal_f_int16( j ) );
    
end

fir_output = single(fir_output)/(2^frac_n);


%% MATLAB FIR FILTERING

Hd = fir_blackman_200_800;
b = Hd.Numerator;
a = 1;

fir_output_m = filter(b, a, adc_signal);

%% PLOT IN TIME

figure
subplot(2,1,1)
plot(t, adc_signal_f, '-b', 'LineWidth', 2)
legend('INPUT SIGNAL')
grid on

subplot(2,1,2)
plot(t, fir_output_m, '-b', 'LineWidth', 2)
hold on
plot(t, fir_output, '--r')
legend('FIR OUTPUT MATLAB', 'FIR OUTPUT C')
grid on

%% PLOT IN FREQ

[f1, mag_s ] = my_dft(adc_signal_f, Fs);
[f2, maf_f ] = my_dft(fir_output, Fs);
[f3, maf_m ] = my_dft(fir_output_m, Fs);

figure
plot(f1, mag_s, '-k', 'LineWidth', 2)
hold on
plot(f2, maf_f, '--b', 'LineWidth', 2)
plot(f2, maf_m, '--r', 'LineWidth', 2)
legend('INPUT SIGNAL', 'FIR OUTPUT C' , 'FIR OUTPUT MATLAB')
grid on
