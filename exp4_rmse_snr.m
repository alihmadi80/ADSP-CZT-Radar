% =========================================================================
% Experiment 4: RMSE vs. SNR (Monte Carlo Simulation)
% =========================================================================
clear; clc; 
rng('default');

Fs = 1e6;       
N = 256;        
f1 = 100e3;     % Primary Target for tracking
f2 = 105e3;     % Secondary Target
snr_range = 0:5:30;
num_trials = 100; % 100 Monte Carlo trials per SNR

rmse_pad = zeros(length(snr_range), 1);
rmse_czt = zeros(length(snr_range), 1);

% Zero-Padding Setup
pad_factor = 16;
N_pad = N * pad_factor;
f_pad = (0:N_pad-1) * (Fs/N_pad);
[~, pad_idx_min] = min(abs(f_pad - 95e3));
[~, pad_idx_max] = min(abs(f_pad - 103e3));

% CZT Setup
M_czt = 256;          
f_start = 95e3;       
f_end = 103e3;        
beta = 6;

fprintf('Running Monte Carlo Simulation (%d trials per SNR). Please wait...\n', num_trials);

for i = 1:length(snr_range)
    snr = snr_range(i);
    err_pad_sq = 0;
    err_czt_sq = 0;
    
    for trial = 1:num_trials
        % 1. Generate Signal
        [x, ~] = signal_gen(Fs, N, f1, f2, snr);
        
        % 2. Zero-Padded FFT Estimation
        x_pad_win = x .* kaiser(N, beta);
        X_pad = fft(x_pad_win, N_pad);
        Mag_pad = abs(X_pad(pad_idx_min:pad_idx_max));
        [~, max_idx_pad] = max(Mag_pad);
        est_f_pad = f_pad(pad_idx_min + max_idx_pad - 1);
        err_pad_sq = err_pad_sq + (est_f_pad - f1)^2;
        
        % 3. CZT Estimation
        [f_czt, X_czt] = czt_radar_zoom(x, Fs, f_start, f_end, M_czt, beta);
        [~, max_idx_czt] = max(abs(X_czt));
        est_f_czt = f_czt(max_idx_czt);
        err_czt_sq = err_czt_sq + (est_f_czt - f1)^2;
    end
    
    rmse_pad(i) = sqrt(err_pad_sq / num_trials);
    rmse_czt(i) = sqrt(err_czt_sq / num_trials);
end

fprintf('Simulation Complete!\n');

% Plotting the RMSE (Logarithmic Scale)
figure('Position', [250, 250, 700, 500]);
semilogy(snr_range, rmse_pad, '-ob', 'LineWidth', 2, 'MarkerSize', 8); hold on;
semilogy(snr_range, rmse_czt, '-sr', 'LineWidth', 2, 'MarkerSize', 8);
grid on;
xlabel('Signal-to-Noise Ratio (SNR) [dB]');
ylabel('RMSE of Frequency Estimation (Hz)');
title('Robustness: RMSE vs. SNR (100 Monte Carlo Trials)');
legend('Zero-Padded FFT', 'Proposed CZT Zoom', 'Location', 'NorthEast');
set(gca, 'FontSize', 12);