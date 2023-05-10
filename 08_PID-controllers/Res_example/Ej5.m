clc
clear
close all


G_p = zpk(-2, [-1, -10], 2)




%% simulations 
t = 0:.1:100;

K_values = 1:1:10;
a_values = 1:1:10;
b_values = 1:1:10;

th = 5/100;

results = zeros(length(K_values)*length(a_values)*length(b_values), 7);

i = 1;
for K = K_values
    for a = a_values
        for b = b_values
            c_r = step(Ej5_H_r(Ej5_G_c(K, a, b), G_p), t);
            overshoot = max(c_r);
            settling_time_r = max(t((1+th)<c_r | c_r<(1-th)));
            if isempty(settling_time_r)
                settling_time_r = nan;
            end
            
            c_d = step(Ej5_H_d(Ej5_G_c(K, a, b), G_p), t);
            settling_time_d = max(t((1+th)<c_d | c_d<(1-th)));
            steadystate_error = c_d(end) - 0;
            if isempty(settling_time_d)
                settling_time_d = nan;
            end
            
            results(i, :) = [K, a, b, overshoot, settling_time_r, ...
                settling_time_d, steadystate_error];
            i = i + 1;
        end
    end
end


plot(results)
i = 912
K = results(i, 1)
a = results(i, 2)
b = results(i, 3)
figure
step(Ej5_H_d(Ej5_G_c(K, a, b), G_p), t)
figure
step(Ej5_H_r(Ej5_G_c(K, a, b), G_p), t)


