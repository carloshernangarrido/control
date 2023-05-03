function G_c = G_c_Ej5(K, a, b)

G_c = zpk([-1/a -1/b], 0, K*a*b);

end

