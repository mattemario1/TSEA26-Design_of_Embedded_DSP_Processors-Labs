% Load noisy input data into x
x = read_hex('IOS0010');

Fs = 500; % Sampling frequency
cutoff = 15;
N = length(x);
t = (0:N - 1) / Fs; % time axis

% Create a low pass filter with a cut-off frequency of 15 Hz

order = 31;
h = fir1(order, (cutoff/(Fs/2))); % FIXME - Insert the correct value here!

% Matlab based filtering
y = filter(h, 1, x);

% Read results from file
if exist('IOS0011', 'file')
    y_senior = read_hex('IOS0011');
else
    fprintf('Warning: IOS0011 output from srsim not found!\n');
    y_senior = zeros(1, length(y));
end

% Check that results has expected length
if length(y_senior) ~= length(y)
    error('Length of output signal from Senior not the same length as the reference output.')
end

relerr = visualize_timedomain(x, y, y_senior, t, h);
fprintf('Relative error of Senior implementation compared to Matlab implementation: %f\n', relerr);
visualize_freqdomain(x, y, h, Fs);
