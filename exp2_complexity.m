% =========================================================================
% Experiment 2: Computational Runtime vs. Zoom Factor
% =========================================================================
clear; clc; 
rng('default');

Fs = 1e6;       
N = 256;        
x = randn(N, 1) + 1j*randn(N, 1); % Dummy signal for speed test

zoom_factors = [2, 4, 8, 16, 32, 64, 128];
time_pad = zeros(length(zoom_factors), 1);
time_czt = zeros(length(zoom_factors), 1);

M_czt = 256; % Fixed output size for CZT
f_start = 90e3; 
f_end = 112e3;
beta = 6;

for i = 1:length(zoom_factors)
    zf = zoom_factors(i);
    N_pad = N * zf;
    
    % Test Zero-Padded FFT
    tic;
    X_pad = fft(x, N_pad);
    time_pad(i) = toc;
    
    % Test CZT (Matching the resolution of Zero-Padding)
    % CZT resolution = (f_end - f_start) / M_czt. 
    % We keep M_czt constant, so runtime is stable!
    tic;
    [~, ~] = czt_radar_zoom(x, Fs, f_start, f_end, M_czt, beta);
    time_czt(i) = toc;
end

% Plotting
figure('Position', [150, 150, 700, 500]);
plot(zoom_factors, time_pad * 1000, '-ob', 'LineWidth', 2, 'MarkerSize', 8); hold on;
plot(zoom_factors, time_czt * 1000, '-sr', 'LineWidth', 2, 'MarkerSize', 8);
grid on;
xlabel('Spectral Zoom Factor (N_{pad} / N)');
ylabel('Execution Time (milliseconds)');
title('Computational Complexity: Zero-Padded FFT vs. CZT');
legend('Zero-Padded FFT', 'CZT (Proposed)', 'Location', 'NorthWest');
set(gca, 'FontSize', 12);