
n = 0:100;
x = sin(0.5*n);


y = filter([1 1]/2, 1, x);


figure
plot(n', [x', y'])
grid on