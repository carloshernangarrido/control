clear
clc
close all


A_s = [ 0 1
      0 -1];
B_u = [ 0
        1];
B_v = [ 0
        1];
C = [1 0];

% x_dot = A*x + B_u*u + B_v*v
% y     = C*x + w

rv = 0.1 % variance (sigma_v^2) only state x2
Rv = B_v*rv*B_v'
Rw = 0.01 % variance (sigma_w^2)

%% 1. Encuentre el valor de la matriz de covarianza P al resolver la 
% ecuaci�n de Ricatti correspondiente.

% help [X,L,G] = care(A,B,Q)
% A'*X + X*A - X*B*B'*X + Q = 0
% X = X', Q = Q'

% Kalman theory in Feedback systems book of Astrom
% P*A_s' + A_s*P + Rv - P*C'*inv(Rw)*C*P = 0

% A = A_s'
% X = P
% Q = Rv
% B*B' = C'*inv(Rw)*C 
% B*B' = (sqrt(inv(Rw))*C)' * (sqrt(inv(Rw))*C) 
% B' = (sqrt(inv(Rw))*C) 
% B = (sqrt(inv(Rw))*C)'
% [X,L,G] = care(A,B,Q)

  [P,~,~] = care(A_s',(sqrt(inv(Rw))*C)',Rv)

%% 2. Encuentre el valor de la matriz de ganancia de observaci�n L.
L = P*C'*inv(Rw)
[L,~,~] = (lqr(A_s', C', Rv, Rw));
L = L'
syms s
obsv_poles = double(solve(det(s*eye(2) - (A_s-L*C)), s))
proto_obs = zpk([], obsv_poles, 1);
figure
subplot(1,2,1)
pzmap(proto_obs)
xlim([-3, 0])
ylim([-3, 3])
subplot(1,2,2)
step(proto_obs, 0:.01:5)
xlim([0, 5])
ylim([0, .35])

%% 3. Si aumenta el ruido del proceso Rv
Rv_larger = Rv*10
[P_new,~,~] = care(A_s',(sqrt(inv(Rw))*C)', Rv_larger)
L_new = P_new*C'*inv(Rw)
[L_new,~,~] = (lqr(A_s', C', Rv_larger, Rw));
L_new = L_new'
obsv_poles = double(solve(det(s*eye(2) - (A_s-L_new*C)), s))
proto_obs = zpk([], obsv_poles, 1);
figure
subplot(1,2,1)
pzmap(proto_obs)
xlim([-3, 0])
ylim([-3, 3])
subplot(1,2,2)
step(proto_obs, 0:.01:5)
xlim([0, 5])
ylim([0, .35])

% Si el proceso tiene m�s ruido, relativamente debo confiar mas en la
% medici�n.
% Para darle m�s peso a la medici�n tengo que aumentar la ganancia del
% observador L
% Si aumenta L, el t�rmino L*C le resta m�s a A_s, haciendo que tenga
% valores m�s chicos y por lo tanto sea m�s r�pida.
% Pensemos en el coeficiente 2,1 de A como -M\K, es decir el inverso de la
% frecuencia natural


  
