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

C=[[-1 0 1 0 0];
    [cs/mc ds/mc -cs/mc -ds/mc 1/mc]];
% y1 = spring deformation
% y2 = chassis acceleration


%% 1 Observability
W_r = obsv(A, C)
rank(W_r)
if rank(W_r) == 5
    disp("it is observable with ")
    C
end

%% 2 Observability measuring damper deformation
C = [-1 0 1 0 0]
W_r = obsv(A, C)
if det(W_r) ~= 0
    disp(["it is observable with C = " num2str(C)])
end

%% 3 Observability measuring wheel position
C = [1 0 0 0 0]
W_r = obsv(A, C)
if det(W_r) ~= 0
    disp(["it is observable with C = " num2str(C)])
end

%% 4 Sensor choice

% measuring damper deformation


