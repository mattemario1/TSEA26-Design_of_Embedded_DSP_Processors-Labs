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



% % --- 2. Scaling Calculation ---
% MaxVal = max(abs(h));

% % The target maximum value for signed 16-bit is 2^15 - 1 = 32767
% MAX_16BIT = 32767; 

% % Calculate the scaling factor
% Scale = 2; 

% % Scale the original coefficients
% ScaledCoeffs = h * Scale;

% % --- 3. Rounding ---
% % Round to the nearest integer to get the final 16-bit integer values
% IntCoeffs = round(ScaledCoeffs);


% % --- 4. Verification (Optional but Recommended) ---
% % Check that all values are within the 16-bit range [-32768, 32767]
% if (max(IntCoeffs) > MAX_16BIT) || (min(IntCoeffs) < -32768)
%     disp('Warning: Values outside the 16-bit signed range.');
% else
%     disp('All scaled and rounded values are safely within 16-bit range.');
% end

% % --- 5. Conversion to 4-digit Hexadecimal ---
% % Use dec2hex with format 4 to ensure 4 hex digits (16 bits)
% HexCoeffs = dec2hex(IntCoeffs, 4);

% % Display the results
% disp(' ');
% disp('Original Coefficients:');
% disp(h);
% disp('Scaling Factor:');
% disp(Scale);
% disp('16-bit Integer Coefficients:');
% disp(IntCoeffs);
% disp('4-digit Hexadecimal Coefficients:');
% disp(HexCoeffs);

for i = 1:length(h)
    % Get the hex string (a 16-character string for double-precision)

    % h_single = single(h(i))
    hexString = num2hex(single(h(i)));
    
    % Print the index, the scaled value, and the hex string
    fprintf('%s\n', hexString);
end
