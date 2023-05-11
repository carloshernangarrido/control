%---------------------------------------------------
% Exercises on Section Assignment 3 - Active suspension control design
% Model parameters
%---------------------------------------------------

mc=401;                         % Quarter car mass [kg]
mw=48;                          % Wheel mass [kg]
ds=2200;                        % Suspension damping coefficient [Ns/m]
cs=23000;                       % Suspension spring coefficient [N/m]
cw=250000;                      % Wheel spring coefficient [N/m]
tau=0.001;                      % Actuator time constant [s]

%---------------------------------------------------
% The active suspension model
% A, B, C, and H matrices
%---------------------------------------------------
A=[[0 1 0 0 0];[-(cw+cs)/mw -ds/mw cs/mw ds/mw -1/mw];[0 0 0 1 0];[cs/mc ds/mc -cs/mc -ds/mc 1/mc];[0 0 0 0 -1/tau]];
B=[0 0 0 0 1/tau]';
H=[0 cw/mw 0 0 0]';

C=[[-1 0 1 0 0];[cs/mc ds/mc -cs/mc -ds/mc 1/mc]];
% y1 = spring deformation
% y2 = chassis acceleration

%---------------------------------------------------
% Enter your control design here
%---------------------------------------------------
% Qx=
% Qu=
% K=

SYS = ss(A, B, C, zeros(2, 1));

umax = 1000
y1max = 0.05
y2max = 5.0


% a)


% b)
alpha1 = 1
alpha2 = 1
rho = .00000015
Qy = diag([alpha1/(y1max^2), alpha2/(y2max^2)])

% x'*Qx*x = y'*Qy*y
% x'*Qx*x = (C*x)'*Qy*(C*x)
% x'*Qx*x = x'*C'*Qy*Cx
Qx = C'*Qy*C

Qu = rho

[K,S,e] = lqr(SYS,Qx,Qu)

% c)
% kr = 01 because it is a regulator problem, not a 
% servo-controller

%---------------------------------------------------
% For simulation purposes (do not modify)
%---------------------------------------------------
B1=[B H];                   % Put the B and H matrix together as one matrix B1 (for Simulink implementation purposes) 
C1=eye(5);                  % Output all state variables from the model
D1=zeros(5,2);              % Corresponding D matrix
