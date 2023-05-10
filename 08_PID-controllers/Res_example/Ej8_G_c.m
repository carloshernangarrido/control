function G_c = Ej8_G_c(alpha, beta, gamma, A)
    %% parallel PID + filter
    G_c = tf(alpha,1) + tf(beta,[1 0]) + tf([gamma 0], 1);
    G_c = G_c / A;
end

