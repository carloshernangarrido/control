clear
clc
close all

%% Model
% m * h_ddot = m*g - (k*i^2)/h
% V = L i_dot + i*R

% h_dot  = h_dot
% h_ddot = g - (k*i^2)/(h*m) = g - ((h^-1)*k*i^2)/m 
% i_dot  = -i*R/L + (1/L)*V

k = 0.0001
m = 0.05
g = 9.81
L = .01
R = 1


% Linearization about 
h_eq = 0.01
syms i
i_eq = solve(h_eq - k*i^2/(m*g), i);
i_eq = double(abs(i_eq(1)))

h_ddot_eq = (g - (k*i_eq^2)/(h_eq*m))
slope_h_ddot_eq_wr2i = - 2*k*i_eq/(h_eq*m)
slope_h_ddot_eq_wr2h = ((h_eq^-2)*k*i_eq^2)/m

i_test = i_eq + 1;
h_ddot = g - (k*i_test^2)/(h_eq*m);
lin_h_ddot = h_ddot_eq + slope_h_ddot_eq_wr2i*(i_test - i_eq);
linearization_error = (h_ddot/lin_h_ddot)-1

% x1 = Delta_h
% x2 = Delta_h_dot
% x3 = i

% Delta_h_dot = Delta_h_dot
% Delta_h_ddot = slope_h_ddot_eq*i
% i_dot  = i*R/L - (1/L)*V


A = [   0                       1   0
        slope_h_ddot_eq_wr2h    0   slope_h_ddot_eq_wr2i
        0                       0   -R/L]

% A = [   0   1   0 
%         980 0   -2.8
%         0   0   -100 ]
B = [   0 
        0 
        100 ];


%% 1. Defina la matriz C.
% x = [ Delta_h 
%       Delta_h_dot
%       Delta_i ]

C = [1 0 0];
Wo = obsv(A, C)
rank(Wo)

%% 2. Se determina que los polos dominantes a lazo cerrado del sistema deben ser
% p1 = - 20 + 20i
% p2 = - 20 - 20i
% Determine el valor de K y kr. Utilice el método de Ackerman.
Wr = ctrb(A, B)
rank(Wr)
p = [-20-1i*20 -20+1i*20 -5*20]
K = acker(A, B, p)

B_d = [ 0
        1
        0 ];
    
kr = -1/((C*inv(A-B*K))*B)

p_obsv = 5*p;
L_obs = (acker(A', C', p_obsv))';

ki = 100

% 3. Mida el valor del sobrepico y el tiempo de establecimiento de y.