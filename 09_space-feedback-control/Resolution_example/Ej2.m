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


%% 1 Poles to asign
omega_n = 6;
zeta = 1/sqrt(2);

p1 = -zeta*omega_n + 1i*sqrt(1- zeta^2)*omega_n;
p2 = -zeta*omega_n - 1i*sqrt(1- zeta^2)*omega_n;
p3 = -2*zeta*omega_n;
P = [p1, p2, p3];
pzmap(zpk([],P,1));


%% 2 Ackerman formula
K = acker(A, B, P)

%% 3 Value of kr
kr = -inv((C/(A-B*K))*B)


