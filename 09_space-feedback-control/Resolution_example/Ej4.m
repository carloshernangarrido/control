clc
clear
close all

%% Parameters



%% State space system
A    = [ -1.25       0
          0.00005   -0.0024];
    
B_u = [20000 0]';

B_d = [0 -9.82]';

C = [0 1];

D = [0];

% x = [x1 x2]
% x1 = fuerza tangencial en las ruedas
% x2 = velocidad tangencial en las ruedas
% u = acción de control
% d = perturbación = sin(alpha)


%% 1 Controlabilidad
W_r = ctrb(A, B_u);

if rank(W_r) == size(A)
    disp("it is controlable")
else
    disp("it is not controlable")
end


%% 2 Characteristic polynomial
omega_n = 0.6;
zeta = 1 / sqrt(2);

p1 = -zeta*omega_n + 1i*sqrt(1- zeta^2)*omega_n;
p2 = -zeta*omega_n - 1i*sqrt(1- zeta^2)*omega_n;
P = [p1, p2];

stepinfo(zpk(1,P,1))

K = acker(A, B_u, P)
pzmap(ss(A-B_u*K, B_u, C, D));

%% 3 Value of kr
kr = -1/((C/(A-B_u*K))*B_u)

%% simulation
ue = 0
alpha = 0
% equilibrium
x1e = 0
x2e = 0
C_ss = eye(2);
ref_at1 = 20

