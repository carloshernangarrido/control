clc
clear
close all

%% Parameters
Jc = 6250;
Jf = 0.625;
ds = 1000;
cs = 75000;
i = 57;


%% State space system
A    = [ -ds/(Jf*i^2) ds/(Jf*i) -cs/(Jf*i)
         ds/(Jc*i)    -ds/Jc    cs/Jc
         1/i          -1        0 ];
    
B = [1/Jf 0 0]';

B_d = [0 -1/Jc 0]';

C = [0 1 0];

D = [0];

% states
% x1 = engine velocity
% x2 = wheel velocity
% x3 = torque in driveshafts


%% 1 Observability
W_r = obsv(A, C)
if det(W_r) ~= 0
    disp(["it is observable with C = " num2str(C)])
end

%% 1. Determine el polinomio deseado para un overshoot del 2% y un 
% settling time de 1 s para la variable de salida del sistema
t_s = 1;
M_p = 2/100;
sigma = -4/t_s % 2% criterior valid for subcritical damping
omega_d = -pi*sigma/log(M_p);

ctrl_poles = [sigma + 1i*omega_d, sigma - 1i*omega_d, 5*sigma]
proto_sys = zpk([], ctrl_poles, 1);
stepinfo(proto_sys)
figure
subplot(1,2,1)
pzmap(proto_sys)
subplot(1,2,2)
step(proto_sys, 0:.01:5)

K = acker(A, B, ctrl_poles)

kr = -1/((C/(A-B*K))*B)


%% Observer design
% 2 times faster than the controller
obsv_poles = 2*real(ctrl_poles) + 1i*imag(ctrl_poles)
proto_obs = zpk([], obsv_poles, 1);
stepinfo(proto_obs)
figure
subplot(1,2,1)
pzmap(proto_obs)
subplot(1,2,2)
step(proto_obs, 0:.01:5)

L = (acker(A', C', obsv_poles))'



