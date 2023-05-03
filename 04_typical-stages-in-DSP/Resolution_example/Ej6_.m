%% 6.1
q1 = quantizer('fixed','floor','saturate',[32 0]); 
q2 = quantizer('fixed','floor','saturate',[32 8]); 
q3 = quantizer('fixed','floor','saturate',[32 16]);
%% 6.2
u = linspace(-17000,17000,10000000);
%% 6.3
y1=quantize(q1,u);
y2=quantize(q2,u);
y3=quantize(q3,u);
%% 6.4
figure (1)
hold on 
plot(u,u,'linewidth',2)
plot(u, y1, 'linewidth', 2)
plot(u, y2, 'linewidth', 2)
plot(u, y3, 'linewidth', 2)
legend('u', 'y1', 'y2', 'y3')
disp("Errores")
r1 = rms(u-y1)
r2 = rms(u-y2)
r3 = rms(u-y3)
