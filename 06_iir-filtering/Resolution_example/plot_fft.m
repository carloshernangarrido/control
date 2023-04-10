function [ax1, ax2] = plot_fft(x, fs)
    X = fft(x);
    X_abs = abs(X);
    X_angle = angle(X);
    subplot(2,1,1)
    hold on
    ax1 = plot(linspace(0, fs/2, round(length(X)/2)), X_abs(1:round(length(X)/2)), 'linewidth', 2);
    ylabel('mag');
    subplot(2,1,2)
    hold on
    ax2 = plot(linspace(0, fs/2, round(length(X)/2)), X_angle(1:round(length(X)/2)), 'linewidth', 2);
    ylabel('phase (rad)');
    xlabel('f (Hz)')