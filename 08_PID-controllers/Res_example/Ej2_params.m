clc
clear
close all

m = 1000  % kg
g = 9.82  % m/s2
a = 200   % Ns/m
b = 10000 % N/rad

reference = [   0,      25
                9.99,   25
                10,     30
                10.01,  30] % m/s

disturbance = [     0,      0
                    19.99,  0
                    20,     2
                    20.01,  2] % deg
disturbance(:,2) = disturbance(:,2) * pi / 180

%% Controller
G_c = 1 % not so good