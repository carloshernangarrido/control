clc; close all; clear

%% Basic parameters
% gravity
g = 9.8 % m/s^2

% Mass
m = 100  % kg

% vertical cable length
L = 1

% Actuator
f_min = 0 %-inf
f_max = inf

%% Governing equations
%   m qx_ddot = 0.707 T2      + m g sin(theta)
%   m qy_ddot = T1 + 0.707 T2 - m g cos(theta)

%% Estate space model
% State
% x = [ qx qy qx_dot qy_dot ]^T, qx = horizontal displacement, qy = vertical
% displacement

% Control action
% u = [ T1 T2 ], T1 = vertical cable tension, T2 = diagonal cable tension

% Disturbance
% d_1 = gravity_y = m*g * cos(atan2(q_x, q_y - L))
% d_2 = gravity_x = m*g * sin(atan2(q_x, q_y - L))

% Performance observed variables
% y_p = [ qx qy qx_dot qy_dot ]^T

% Sensor observed variables
% y_s = [ qx qy ]^T

% Natural Damping
c = 1000

A = [ 0 0 1     0
      0 0 0     1
      0 0 -c/m  0
      0 0 0     -c/m ]

B_u = [ 0   0
        0   0
        0   0.707/m 
        1/m 0.707/m ]

B_d =  [ 0    0
         0    0
         1/m  0
         0   -1/m ]

C_p = [ 1 0 0 0
        0 1 0 0 ]

C_s = [ 1 0 0 0
        0 1 0 0 ]
    
D_pu = zeros(4, 2)

D_pd = zeros(4, 1)
    
D_su = zeros(2, 2)

D_sd = zeros(2, 1)

%% Control design
%% Stabilization
% Critically damped modes (Astrom and Murray, Table 6.1: Properties of the step response for a second-order system with 0 <? < 1)
S_t = 5 % s
omega_0 = 5.8/S_t
p = -(omega_0) * [ 1 1 10 10 ]

K = place(A, B_u, p)

%% Reference tracking
k_r = -inv(C_p*inv(A -B_u*K)*B_u)

% square of length l
len = .5
a = len/5


%% Integral action + Reference tracking
% Augmented state
% x = [ qx qy qx_dot qy_dot z]^T, 
% qx = horizontal displacement, 
% qy = vertical displacement,
% qx = horizontal velocity, 
% qy = vertical velocity,
% z = integral of the error [ y_p_0-r_0 y_p_1-r_1 ]^T
% z_dot = y_p - r

A_aug = [ A         zeros(4, 2)
          -C_p      zeros(2, 2) ];

B_aug = [ B_u
          zeros(2, 2) ];

C_p_aug = [ C_p         zeros(2,2)
            zeros(2,4)  eye(2) ]

D_aug = [ D_pu
          zeros(2, 2) ];

% Augmented system matrices for integral action
A_aug = [ A         zeros(4, 2)
          -C_p      zeros(2, 2) ];

B_aug = [ B_u
          zeros(2, 2) ];

C_aug = [ C_p zeros(2, 2) ];

D_aug = [ D_pu
          zeros(2, 2) ];

% Augmented state feedback gain
% Desired poles for the augmented system
p_aug = [ p -10 -10 ]; % Adding two more poles for the integral states

% Compute the augmented state feedback gain
K_aug = place(A_aug, B_aug, p_aug);

% Extract the original state feedback gain and the integral gain
K_when_K_i = K_aug(:, 1:4)
K_i = K_aug(:, 5:6)

% Updated Reference tracking
k_r_when_K_i = -inv(C_p*inv(A -B_u*K_when_K_i)*B_u)


%% Integral Action with LQR + Reference Tracking
% Compute the augmented state feedback gain
error_x_typ = .1  % m
error_y_typ = .01  % m
zx_typ = .01 * 5   % m s
zy_typ = .01 * 5   % m s
Qp_aug = [ 1/error_x_typ^2  0                 0          0
           0                1/error_y_typ^2   0          0
           0                0                 1/zx_typ^2 0 
           0                0                 0          1/zy_typ^2 ]
Qx_aug = C_p_aug' * Qp_aug * C_p_aug

T1_typ = 1000
T2_typ = 500
Qu_aug = [ 1/T1_typ^2 0
           0          1/T2_typ^2 ]

K_aug_lqr = lqr(A_aug, B_aug, Qx_aug, Qu_aug);

% Extract the original state feedback gain and the integral gain
K_when_K_i_lqr = K_aug_lqr(:, 1:4)
K_i_lqr = K_aug_lqr(:, 5:6)

% Updated Reference tracking
k_r_when_K_i_lqr = -inv(C_p*inv(A -B_u*K_when_K_i_lqr)*B_u)

