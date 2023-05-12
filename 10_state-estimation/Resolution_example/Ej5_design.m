clc
clear
close all

Ej4_design


%% Uncertanty
Jc = 6250 *1.1;
Jf = 0.625 *1.1;
ds = 1000*1.1;
cs = 75000*1.05;
i = 57*1.05;
A_real = [ -ds/(Jf*i^2) ds/(Jf*i) -cs/(Jf*i)
         ds/(Jc*i)    -ds/Jc    cs/Jc
         1/i          -1        0 ];
B_real = [1/Jf 0 0]';

ki = 100