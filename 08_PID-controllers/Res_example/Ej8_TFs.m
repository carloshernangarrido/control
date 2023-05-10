function [H_Y_R, H_Y_D] = Ej8_TFs(G_p, G_c1, G_c2)
%% Tranfer functions of 2-DOF PID  
    H_Y_R = (G_c1*G_p) / (1 + G_p*(G_c1 + G_c2));
    H_Y_D = (G_p) / (1 + G_p*(G_c1 + G_c2));

end

