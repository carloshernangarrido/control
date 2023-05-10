function H_r_ = Ej5_H_r(G_c, G_p)
%% Functions Responses
% to unit-step reference
    H_r_ = (G_p*G_c) / (1+ G_p*G_c); % C(s)/R(s), D(s)=0
end

