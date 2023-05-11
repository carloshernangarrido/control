clc; clear; close all;
%---------------------------------------------------
% Section assignment 3.5.2 - Cruise controller with 
% state feedback with intergral action
%
%---------------------------------------------------
% Model parameters
%---------------------------------------------------

m=20000;                % Vehicle mass [kg]
k=2000;                % Engine torque gain factor [Nm/rad]
r=4;                    % Gear ratio (for a specific gear) [-]
tau=0.8;                % Engine time constant [s]
g=9.82;                 % Gravity [m/s^2]
rho=1.2;                % Air density [kg/m^3]
CD=0.5;                 % Drag coefficient [-]
Af=4;                   % Front area [m^2]
rw=0.5;                 % Wheel radius [m]
f=0.015;                % Rolling resistance coefficient [-]\\


%---------------------------------------------------
% Equilibrium point 
%---------------------------------------------------
% x2e=                  % Vehicle velocity [m/s]
% x1e=                  % Wheel force [N]
% ue=                   % Pedal position [rad]
% de=                   % Slope [rad]

x2e=15;                 
x1e=0.5*rho*CD*Af*x2e^2+m*g*f;
ue=rw*x1e/k/r;
de=0;

% x2e=0;                 
% x1e=0;
% ue=0;

%---------------------------------------------------
% Linear longitudinal vehicle dynamics model 
% A, B, C, D and H matrices
%---------------------------------------------------
A=[[-1/tau 0];[1/m -rho*CD*Af*x2e/m]];
B=[k*r/tau/rw 0]';
H=[0 -g]';
C=[0 1];
D=[0];

%-----------------------------------------------------
% Control design part
% Enter your control design here
%-----------------------------------------------------
% ...
%Kaug=

% System augmented with the integral of the error as a new state variable
Aaug = [ A zeros(2,1)
         C 0]
Baug = [ B
         0]
Faug = [ zeros(2,1)
        -1]

% Pole placement
omega_n = 6;
zeta = 1/sqrt(2);
p1 = -zeta*omega_n + 1i*sqrt(1- zeta^2)*omega_n;
p2 = -zeta*omega_n - 1i*sqrt(1- zeta^2)*omega_n;
p3 = -3*zeta*omega_n;
P = [p1, p2, p3];
figure;
subplot(1,2,1);
pzmap(zpk([],P,1));
overshoot_M_p = exp(-pi*zeta/sqrt(1 - zeta^2))
sigma = zeta*omega_n;
settling_time = 4/sigma 


subplot(1,2,2);
Kaug = acker(Aaug, Baug, P)
tfaug = ss(Aaug-Baug*Kaug, Baug, [0 1 0], 0);
pzmap(tfaug);

% disturbance
alpha_ = 2*pi/180;

%---------------------------------------------------
% For simulation purposes (do not modify)
%---------------------------------------------------
B1=[B H];                   % Put the B and H matrix together as one matrix B1 (for Simulink implementation purposes) 
C1=eye(2);                  % Output all state variables from the model
D1=zeros(2);              % Corresponding D matrix

