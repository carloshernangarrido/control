clc
clear
close all


% Based in OGATA (2010): 
% 8–7 ZERO-PLACEMENT APPROACH TO IMPROVE RESPONSE CHARACTERISTICS
G_p = zpk(-1, [0 -3 -5], 2)
G_p_num = zpk(-1,[], 1)

% Use of filter 1/G_p_num in G_c1 and G_c2: Allows following step reference
% input

% H_Y_R = (G_c1*G_p) / (1 + G_p*(G_c1 + G_c2));
% H_Y_D = (G_p) / (1 + G_p*(G_c1 + G_c2));
% G_c1 + G_c2 = G_c = (alpha + beta/s + gamma*s) / G_p_num

    
    
% Zero Placement:
% Zeros of H_Y_R for following step, ramp and acceleration reference input
% p(s) = a_2*s2 + a_1*s + a_0 = a_2 *(s+s_1) * (s+s_2)


%% simulations 
t = 0:.1:20;

th_rel = 5/100;

%% First step: 

kp2 = 0;
ki2 = 0;
kd2 = -15/2;

kp1_values = 0:5:50
ki1_values = 0:5:50
kd1_values = 0:5:100 


d_settling_time_min = 1
d_settling_time_max = 2
r_settling_time_max = 1
r_overshoot_max = 1.2

results = zeros(length(kp1_values)*length(ki1_values)*length(kd1_values), 6);
i = 1;
for kp1 = kp1_values
    for ki1 = ki1_values
        for kd1 = kd1_values
            G_c1 = Ej8_G_c(kp1, ki1, kd1, G_p_num);
            G_c2 = Ej8_G_c(kp2, ki2, kd2, G_p_num);
            [H_Y_R, H_Y_D] = Ej8_TFs(G_p, G_c1, G_c2);
                        
            c_d = step(H_Y_D, t);
            th = th_rel;
            settling_time_d = max(t((th<c_d) | (c_d<-th)));
            if isempty(settling_time_d)
                settling_time_d = nan;
            end
            
            c_r = step(H_Y_R, t);
            settling_time_r = max(t((th<(c_r-1)) | ((c_r-1)<-th)));
            if isempty(settling_time_r)
                settling_time_r = nan;
            end
            overshoot_r = max(c_r);                        
            
%             if (settling_time_d > d_settling_time_min) && (settling_time_d < d_settling_time_max)
                results(i, :) = [kp1, ki1, kd1, ...
                    settling_time_d, settling_time_r, overshoot_r];
                i = i + 1;
%             end
        end
    end
end

% results_feasible = results((results(:,4) < d_settling_time_max) & (results(:,4) > d_settling_time_min)...
%                          & (results(:,5) < r_settling_time_max)...
%                          & (results(:,6) < r_overshoot_max), :);

results_feasible = results((results(:,5) < r_settling_time_max)...
                         & (results(:,6) < r_overshoot_max), :);
       
i = 11
kp1 = results_feasible(i, 1)
ki1 = results_feasible(i, 2)
kd1 = results_feasible(i, 3)
G_c1 = Ej8_G_c(kp1, ki1, kd1, G_p_num);
G_c2 = Ej8_G_c(kp2, ki2, kd2, G_p_num);
[H_Y_R, H_Y_D] = Ej8_TFs(G_p, G_c1, G_c2);
figure
step(H_Y_D, t);
title("response to step disturbance input")
figure
step(H_Y_R, t)
title("response to step reference input")


