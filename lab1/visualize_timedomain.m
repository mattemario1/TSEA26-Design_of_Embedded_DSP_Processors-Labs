function relerr = visualize_timedomain(x, y, y_senior, t, h)

    figure();
    set(gcf, 'name', 'Time domain analysis');

    % plot noisy signal
    subplot(4, 1, 1), plot(t, x);
    xlabel('t [s]');
    title('ECG + 50 Hz noise');

    subplot(4, 1, 2), plot(h, '.');
    title(sprintf('FIR filter of %d taps', length(h)));

    subplot(4, 1, 3), plot(t, y);
    xlabel('t [s]');
    title('Signal as recovered by Matlab');

    subplot(4, 1, 4), plot(t, y_senior);
    xlabel('t [s]');

    relerr = norm(y - y_senior) / norm(y);
    title(sprintf('Signal as recovered by Senior (rel.error=%f)', relerr));

    return
