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
% B_d = [0 -1/Jc 0]';
C = [0 1 0];
D = [0];

%% 1. Determine R
% x2 = angular velocity at the wheel = theta_dot (rad/s)
% sensor = theta = encoder with error:

% Augmented system
% x1 = velocidad angular del motor
% x2 = velocidad angular en las ruedas
% x3 = torque en el eje de transmisión
% x4 = posición angular en las ruedas
% x4_dot = velocidad angular en las ruedas

A    = [ -ds/(Jf*i^2) ds/(Jf*i) -cs/(Jf*i)  0
         ds/(Jc*i)    -ds/Jc    cs/Jc       0
         1/i          -1        0           0
         0            1         0           0];
     
B = [1/Jf 0 0 0]';
% B_d = [0 -1/Jc 0 0]';
C = [0 0 0 1];
D = [0];

dim = 4;


% Observability
W_o = obsv(A, C);
if rank(W_o) < dim
    error('it is not observable')
end

R = (2*pi/180)^2 %  rad^2

%% 2. Determine Q
Q = 0;


%% 3. Valores a priori
x0 = zeros(dim, 1)
x0(3) = .0015;
P0 = zeros(dim, dim)

%% 4. Simulación
t = 0:.05:50;
T_step = 5;
T_down = 25
u = zeros(1, length(t));
U = 1;
for i = 1:length(t)
    if t(i) > T_step && t(i) < T_down
        u(i) = U;
    end
end
sysc = ss(A, B, C, D);
[y,t,x_sim] = lsim(sysc, u, t);

% figure
% hold on
% subplot(2, 2, 1)
% plot(t, x_sim(:, 1), 'linewidth', 3)
% ylabel('engine ang. vel.')
% subplot(2, 2, 2)
% plot(t, x_sim(:, 2), 'linewidth', 3)
% ylabel('wheel ang. vel.')
% subplot(2, 2, 3)
% plot(t, x_sim(:, 3), 'linewidth', 3)
% ylabel('torque')
% subplot(2, 2, 4)
% plot(t, x_sim(:, 4), 'linewidth', 3)
% ylabel('wheel angle')
% xlabel('t (s)')

%% Sistema discreto
Ts = t(2) - t(1);
sysd = c2d( sysc , Ts );

%% Filtro de Kalman discreto
w = sqrt(R)*randn(length(y),1);
R
cov(w)
y_noisy = y + w;

P = P0*eye(4);
x = x0;
ye = zeros(length(t));
errcov = zeros(length(t));
x_est = zeros(length(t), dim);
for i=1:length(t)
  % Measurement update
  Mxn = P*sysd.C'/(sysd.C*P*sysd.C'+R);
  x = x + Mxn*(y_noisy(i)-sysd.C*x);   % x[n|n]
  P = (eye(dim)-Mxn*sysd.C)*P;     % P[n|n]

  ye(i) = sysd.C*x;
  errcov(i) = sysd.C*P*sysd.C';

  % Time update
  x = sysd.A*x + sysd.B*u(i);        % x[n+1|n]
  P = sysd.A*P*sysd.A' + sysd.B*Q*sysd.B';     % P[n+1|n]
  
  x_est(i, :) = x';
end

figure
hold on
subplot(2, 2, 1); hold on;
plot(t, x_sim(:, 1), 'linewidth', 3)
plot(t, x_est(:, 1), 'linewidth', 2)
ylabel('engine ang. vel.')
subplot(2, 2, 2); hold on;
plot(t, x_sim(:, 2), 'linewidth', 3)
plot(t, x_est(:, 2), 'linewidth', 2)
ylabel('wheel ang. vel.')
subplot(2, 2, 3); hold on;
plot(t, x_sim(:, 3), 'linewidth', 3)
plot(t, x_est(:, 3), 'linewidth', 2)
ylabel('torque')
subplot(2, 2, 4); hold on;
plot(t, x_sim(:, 4), 'linewidth', 3, 'displayname', 'sim')
plot(t, x_est(:, 4), 'linewidth', 2, 'displayname', 'est')
plot(t, y_noisy, 'linewidth', 2, 'displayname', 'sensor')
ylabel('wheel angle')
legend
xlabel('t (s)')
suptitle('midiendo u, con Q=0')


%% Filtro de Kalman discreto SIN MEDIR u
y_noisy = y + sqrt(R)*randn(length(y),1);

P = P0*eye(4);
x = x0;
ye = zeros(length(t));
errcov = zeros(length(t));
x_est = zeros(length(t), dim);
for i=1:length(t)
  % Measurement update
  Mxn = P*sysd.C'/(sysd.C*P*sysd.C'+R);
  x = x + Mxn*(y_noisy(i)-sysd.C*x);   % x[n|n]
  P = (eye(dim)-Mxn*sysd.C)*P;     % P[n|n]

  ye(i) = sysd.C*x;
  errcov(i) = sysd.C*P*sysd.C';

  % Time update
%   x = sysd.A*x + sysd.B*u(i);        % x[n+1|n]
  x = sysd.A*x;        % x[n+1|n]
  P = sysd.A*P*sysd.A' + sysd.B*Q*sysd.B';     % P[n+1|n]
  
  x_est(i, :) = x';
end

figure
hold on
subplot(2, 2, 1); hold on;
plot(t, x_sim(:, 1), 'linewidth', 3)
plot(t, x_est(:, 1), 'linewidth', 2)
ylabel('engine ang. vel.')
subplot(2, 2, 2); hold on;
plot(t, x_sim(:, 2), 'linewidth', 3)
plot(t, x_est(:, 2), 'linewidth', 2)
ylabel('wheel ang. vel.')
subplot(2, 2, 3); hold on;
plot(t, x_sim(:, 3), 'linewidth', 3)
plot(t, x_est(:, 3), 'linewidth', 2)
ylabel('torque')
subplot(2, 2, 4); hold on;
plot(t, x_sim(:, 4), 'linewidth', 3, 'displayname', 'sim')
plot(t, x_est(:, 4), 'linewidth', 2, 'displayname', 'est')
plot(t, y_noisy, 'linewidth', 2, 'displayname', 'sensor')
ylabel('wheel angle')
legend
xlabel('t (s)')
suptitle('sin medir u, con Q=0')



%% Filtro de Kalman discreto SIN MEDIR u, con Q realista
Q = var(u)
y_noisy = y + sqrt(R)*randn(length(y),1);

P = P0*eye(4);
x = x0;
ye = zeros(length(t));
errcov = zeros(length(t));
x_est = zeros(length(t), dim);
for i=1:length(t)
  % Measurement update
  Mxn = P*sysd.C'/(sysd.C*P*sysd.C'+R);
  x = x + Mxn*(y_noisy(i)-sysd.C*x);   % x[n|n]
  P = (eye(dim)-Mxn*sysd.C)*P;     % P[n|n]

  ye(i) = sysd.C*x;
  errcov(i) = sysd.C*P*sysd.C';

  % Time update
%   x = sysd.A*x + sysd.B*u(i);        % x[n+1|n]
  x = sysd.A*x;        % x[n+1|n]
  P = sysd.A*P*sysd.A' + sysd.B*Q*sysd.B';     % P[n+1|n]
  
  x_est(i, :) = x';
end

figure
hold on
subplot(2, 2, 1); hold on;
plot(t, x_sim(:, 1), 'linewidth', 3)
plot(t, x_est(:, 1), 'linewidth', 2)
ylabel('engine ang. vel.')
subplot(2, 2, 2); hold on;
plot(t, x_sim(:, 2), 'linewidth', 3)
plot(t, x_est(:, 2), 'linewidth', 2)
ylabel('wheel ang. vel.')
subplot(2, 2, 3); hold on;
plot(t, x_sim(:, 3), 'linewidth', 3)
plot(t, x_est(:, 3), 'linewidth', 2)
ylabel('torque')
subplot(2, 2, 4); hold on;
plot(t, x_sim(:, 4), 'linewidth', 3, 'displayname', 'sim')
plot(t, x_est(:, 4), 'linewidth', 2, 'displayname', 'est')
plot(t, y_noisy, 'linewidth', 2, 'displayname', 'sensor')
ylabel('wheel angle')
legend
xlabel('t (s)')
suptitle('sin medir u, con Q=var(u)')


Q = 0.1*var(u)
y_noisy = y + sqrt(R)*randn(length(y),1);

P = P0*eye(4);
x = x0;
ye = zeros(length(t));
errcov = zeros(length(t));
x_est = zeros(length(t), dim);
for i=1:length(t)
  % Measurement update
  Mxn = P*sysd.C'/(sysd.C*P*sysd.C'+R);
  x = x + Mxn*(y_noisy(i)-sysd.C*x);   % x[n|n]
  P = (eye(dim)-Mxn*sysd.C)*P;     % P[n|n]

  ye(i) = sysd.C*x;
  errcov(i) = sysd.C*P*sysd.C';

  % Time update
%   x = sysd.A*x + sysd.B*u(i);        % x[n+1|n]
  x = sysd.A*x;        % x[n+1|n]
  P = sysd.A*P*sysd.A' + sysd.B*Q*sysd.B';     % P[n+1|n]
  
  x_est(i, :) = x';
end

figure
hold on
subplot(2, 2, 1); hold on;
plot(t, x_sim(:, 1), 'linewidth', 3)
plot(t, x_est(:, 1), 'linewidth', 2)
ylabel('engine ang. vel.')
subplot(2, 2, 2); hold on;
plot(t, x_sim(:, 2), 'linewidth', 3)
plot(t, x_est(:, 2), 'linewidth', 2)
ylabel('wheel ang. vel.')
subplot(2, 2, 3); hold on;
plot(t, x_sim(:, 3), 'linewidth', 3)
plot(t, x_est(:, 3), 'linewidth', 2)
ylabel('torque')
subplot(2, 2, 4); hold on;
plot(t, x_sim(:, 4), 'linewidth', 3, 'displayname', 'sim')
plot(t, x_est(:, 4), 'linewidth', 2, 'displayname', 'est')
plot(t, y_noisy, 'linewidth', 2, 'displayname', 'sensor')
ylabel('wheel angle')
legend
xlabel('t (s)')
suptitle('sin medir u, con Q=0.1*var(u)')


Q = 10*var(u)
y_noisy = y + sqrt(R)*randn(length(y),1);

P = P0*eye(4);
x = x0;
ye = zeros(length(t));
errcov = zeros(length(t));
x_est = zeros(length(t), dim);
for i=1:length(t)
  % Measurement update
  Mxn = P*sysd.C'/(sysd.C*P*sysd.C'+R);
  x = x + Mxn*(y_noisy(i)-sysd.C*x);   % x[n|n]
  P = (eye(dim)-Mxn*sysd.C)*P;     % P[n|n]

  ye(i) = sysd.C*x;
  errcov(i) = sysd.C*P*sysd.C';

  % Time update
%   x = sysd.A*x + sysd.B*u(i);        % x[n+1|n]
  x = sysd.A*x;        % x[n+1|n]
  P = sysd.A*P*sysd.A' + sysd.B*Q*sysd.B';     % P[n+1|n]
  
  x_est(i, :) = x';
end

figure
hold on
subplot(2, 2, 1); hold on;
plot(t, x_sim(:, 1), 'linewidth', 3)
plot(t, x_est(:, 1), 'linewidth', 2)
ylabel('engine ang. vel.')
subplot(2, 2, 2); hold on;
plot(t, x_sim(:, 2), 'linewidth', 3)
plot(t, x_est(:, 2), 'linewidth', 2)
ylabel('wheel ang. vel.')
subplot(2, 2, 3); hold on;
plot(t, x_sim(:, 3), 'linewidth', 3)
plot(t, x_est(:, 3), 'linewidth', 2)
ylabel('torque')
subplot(2, 2, 4); hold on;
plot(t, x_sim(:, 4), 'linewidth', 3, 'displayname', 'sim')
plot(t, x_est(:, 4), 'linewidth', 2, 'displayname', 'est')
plot(t, y_noisy, 'linewidth', 2, 'displayname', 'sensor')
ylabel('wheel angle')
legend
xlabel('t (s)')
suptitle('sin medir u, con Q=10*var(u)')