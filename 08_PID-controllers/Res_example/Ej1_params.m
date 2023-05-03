clc
clear
close all

m = 1500  % kg
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
% if t -> inf   =>   dv/dt = 0
% if d = 0      => a*v / m = b*u /m     =>  v = u*(b/a)
G_c = .01 * (30 / 12.43) * (30 /33.6)