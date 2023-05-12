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

B_d = [0 -1/Jc 0]';

C = [0 1 0];

D = [0];

% states
% x1 = engine velocity
% x2 = wheel velocity
% x3 = torque in driveshafts


%% 1 Observability
W_r = obsv(A, C)
if det(W_r) ~= 0
    disp(["it is observable with C = " num2str(C)])
end

%% 2 Observability with different Cs

if det(obsv(A, [1 0 0])) ~= 0
    disp("it is observable with C = [1 0 0]")
end
if det(obsv(A, [0 1 0])) ~= 0
    disp("it is observable with C = [0 1 0]")
end
if det(obsv(A, [0 0 1])) ~= 0
    disp("it is observable with C = [0 0 1]")
else 
    disp("it is not observable with C = [0 0 1]")
end

%% sensor choice
% Option 1: C = [1 0 0]
% motor speed
% 
% Option 2: C = [0 1 0]
% wheel speed
% 
% Option 2 is better because it coincides with a variable that appears in 
% the control objective
% 

