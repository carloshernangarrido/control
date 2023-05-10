function G_c = Ej5_G_c(K, a, b)

G_c = zpk([-1/a -1/b], 0, K*a*b);

end

