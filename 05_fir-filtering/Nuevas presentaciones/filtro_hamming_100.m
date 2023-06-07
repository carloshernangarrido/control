function Hd = filtro_hamming_100
%FILTRO_HAMMING_100 Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 9.4 and Signal Processing Toolbox 8.0.
% Generated on: 31-May-2023 16:36:21

% FIR Window Lowpass filter designed using the FIR1 function.

% All frequency values are in Hz.
Fs = 200;  % Sampling Frequency

N    = 100;      % Order
Fc   = 10;       % Cutoff Frequency
flag = 'scale';  % Sampling Flag

% Create the window vector for the design algorithm.
win = hamming(N+1);

% Calculate the coefficients using the FIR1 function.
b  = fir1(N, Fc/(Fs/2), 'low', win, flag);
Hd = dfilt.dffir(b);

% [EOF]
