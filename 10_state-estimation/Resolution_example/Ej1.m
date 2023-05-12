clc
clear
close all

m = 1;
c = 1;

A = [0 1
     0 -c/m]
 
%% 1. Observability when y is position
C = [1 0]

W_o = obsv(A,C)
if det(W_o) == 0
    disp("it is not observable")
else
    disp("it is observable")
end

%% 2. Observability when y is velocity
C = [0 1]

W_o = obsv(A,C)
if det(W_o) == 0
    disp("it is not observable")
else
    disp("it is observable")
end
% It is not obsevable because it is imposible to know position from
% velocity, due to unknow initial condition.

%% 3. Observer gain

% pdes(s) = (s+p)^2

% Rule of thumb
% 4*p_sys <= real(p) <= 5*real(p_sys)

C = [1 0];
B = [0; 1];
D = 0;
sys = ss(A, B, C, D);
transfer_function = tf(sys)
syms s
char_poly = charpoly(A, s)

sys_poles = pole(sys)

p = -5*max(abs(sys_poles))


