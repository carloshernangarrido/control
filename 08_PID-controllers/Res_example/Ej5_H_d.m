function H_d_ = Ej5_H_d(G_c, G_p)
%% Functions Responses
% to unit-step disturbance
    H_d_ = G_p / (1+ G_p*G_c); % C(s)/D(s), R(s)=0
end