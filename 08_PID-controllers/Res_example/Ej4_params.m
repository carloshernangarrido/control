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
kp = 1 % 
ki = .1 % 
kd = 0

%% Model of the plant without disturbance
% s*V = (-a/m)*V + (b/m)*U
% s*V + (a/m)*V = (b/m)*U
% (s + (a/m))*V = (b/m)*U
% (s + (a/m))*V = (b/m)*U

% V/U = H_p(s) = (b/m) / ((a/m) + s)

% H(s) = H_p(s)*H_PID(s) / (1 + H_p(s)*H_PID(s))

H_p = tf(b/m, [1 (a/m)])
H_PID_kp = tf(kp, 1);
H_PID_ki = tf(ki, [1 0]);
H_PID_kd = tf([kd 0], 1);
H_PID = H_PID_kp + H_PID_ki + H_PID_kd

H = H_p*H_PID / (1 + H_p*H_PID)

[z,p,k] = tf2zp(H.Numerator{1,1}, H.Denominator{1,1})

figure
pzmap(H)
xlim([-110, 0])
ylim([-1, 1])

%% Symbolic
syms s a_s b_s m_s kp_s ki_s kd_s p_place_s

% V/U = H_p(s) = (b/m) / ((a/m) + s)
H_p_s = (b_s/m_s) / ((a_s/m_s) + s)
H_PID_s = kp_s + (ki_s/s) + s*kd_s
% 
% H_s = (H_p_s*H_PID_s) / (1 + H_p_s*H_PID_s)
% 
% [ N , D ] = numden( H_s )

D = (1 + H_p_s*H_PID_s)

% [kp_solu, ki_solu, kd_solu] = ...
%     solve(coeffs(D, s) == coeffs((s - p_place_s)^2, s), [kp_s, ki_s, kd_s])

[kp_solu, ki_solu, kd_solu] = ...
    solve(solve(D, s) == [p_place_s, p_place_s], [kp_s, ki_s, kd_s])

kp_solu = kp_solu(1)
ki_solu = ki_solu(1)
kd_solu = kd_solu(1)

% particular parameters
p_place = -100

kp = double(subs(kp_solu, [m_s, a_s, b_s, p_place_s], [m, a, b, p_place]))
ki = double(subs(ki_solu, [m_s, a_s, b_s, p_place_s], [m, a, b, p_place]))
kd = double(subs(kd_solu, [m_s, a_s, b_s, p_place_s], [m, a, b, p_place]))


%% Check
H_PID_kp = tf(kp, 1);
H_PID_ki = tf(ki, [1 0]);
H_PID_kd = tf([kd 0], 1);


H_PID = H_PID_kp + H_PID_ki + H_PID_kd

H = H_p*H_PID / (1 + H_p*H_PID)

[z,p,k] = tf2zp(H.Numerator{1,1}, H.Denominator{1,1})

figure
pzmap(H)
xlim([-110, 0])
ylim([-1, 1])


