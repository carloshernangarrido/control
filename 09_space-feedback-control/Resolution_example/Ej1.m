clc
clear
close all

% char poly:
% p(s) = s^2 + 2 * zeta * omega_n * s + omega_n^2

% omega_d = omega_n * sqrt(1 - zeta^2)
% sigma = zeta * omega_n

% M_p = exp(-pi*sigma/omega_d)
% t_s = 3/ sigma = 3 / (zeta*omega_n)   5%

%% Caso A
t_s = 2.0
M_p = 0

sigma = 4/t_s % 2% criterior valid for subcritical damping
sigma = sigma*2
omega_d = -pi*sigma/log(M_p);

% M_p = 0: Critical damping
zeta = 1;
if zeta < 1
    omega_n = omega_d / sqrt(1 - zeta^2);
elseif zeta == 1
    omega_n = sigma;
end

omega_n
zeta
H = tf(omega_n^2, [1,  2*zeta*omega_n, omega_n^2])
figure
subplot(1,2,1)
pzmap(H)
ylim([-2, 2])
subplot(1,2,2)
step(H)


%% Caso B
t_s = 4.0
M_p = 0.1

sigma = 4/t_s
omega_d = -pi*sigma/log(M_p)

syms zeta_ real

zeta = double(solve(M_p - exp(-pi*zeta_/sqrt(1 - zeta_^2)), zeta_))


if zeta < 1
    omega_n = omega_d / sqrt(1 - zeta^2);
elseif zeta == 1
    omega_n = sigma;
end

omega_n
zeta
H = tf(omega_n^2, [1,  2*zeta*omega_n, omega_n^2])
figure
subplot(1,2,1)
pzmap(H)
ylim([-2, 2])
subplot(1,2,2)
step(H)
