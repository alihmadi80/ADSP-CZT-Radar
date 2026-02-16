% =========================================================================
% High-Resolution Spectral Zooming for Radar/Sonar using CZT
% =========================================================================
clear; clc; 

%% 1. Parameters Setup & Fixed Random Seed
rng('default'); % FIXED SEED for exact reproducibility

Fs = 1e6;       % Sampling Frequency: 1 MHz
N = 256;        % Short observation window (creates low Rayleigh resolution)
f1 = 100e3;     % Target 1: 100 kHz
f2 = 102e3;     % Target 2: 102 kHz (Delta f = 2 kHz)
snr_db = 15;    % SNR in dB

% Note: Standard FFT bin resolution = Fs/N = 3906 Hz.
% Since Delta f (2000 Hz) < FFT bin size, standard FFT WILL fail to resolve.

%% 2. Signal Generation
[x, t] = signal_gen(Fs, N, f1, f2, snr_db);

%% 3. Baseline 1: Standard FFT
tic;
X_fft = fft(x);
time_fft = toc;
X_fft_mag = 20*log10(abs(X_fft));
f_fft = (0:N-1) * (Fs/N);

%% 4. Baseline 2: Heavily Zero-Padded FFT
pad_factor = 16;
N_pad = N * pad_factor; 
tic;
% Apply Kaiser window before padding to reduce leakage
x_pad_win = x .* kaiser(N, 6);
X_pad = fft(x_pad_win, N_pad);
time_pad = toc;
X_pad_mag = 20*log10(abs(X_pad));
f_pad = (0:N_pad-1) * (Fs/N_pad);

%% 5. Proposed Method: CZT Zoom
M_czt = 256;          % Keep output size small (efficient)
f_start = 90e3;       % Zoom Start: 90 kHz
f_end = 112e3;        % Zoom End: 112 kHz
beta = 6;             % Kaiser window shape parameter
tic;
[f_czt, X_czt] = czt_radar_zoom(x, Fs, f_start, f_end, M_czt, beta);
time_czt = toc;
X_czt_mag = 20*log10(abs(X_czt));

%% 6. Display Runtime Results
fprintf('--- Computational Runtime (Seconds) ---\n');
fprintf('Standard FFT:       %.6f s\n', time_fft);
fprintf('Zero-Padded FFT:    %.6f s\n', time_pad);
fprintf('CZT Spectral Zoom:  %.6f s\n', time_czt);
fprintf('---------------------------------------\n');

%% 7. Visualization for the Paper
figure('Position', [100, 100, 800, 500]);

% Plot standard FFT
plot(f_fft/1e3, X_fft_mag - max(X_fft_mag), 'k--', 'LineWidth', 1.5); hold on;
% Plot Zero-Padded FFT
plot(f_pad/1e3, X_pad_mag - max(X_pad_mag), 'b', 'LineWidth', 1.5);
% Plot CZT
plot(f_czt/1e3, X_czt_mag - max(X_czt_mag), 'r', 'LineWidth', 2);

xlim([90, 112]); % Zoom into Region of Interest
ylim([-60, 5]);
grid on;
title('Spectral Resolution Comparison: FFT vs. Zero-Pad vs. CZT');
xlabel('Frequency (kHz)');
ylabel('Normalized Magnitude (dB)');
legend('Standard FFT (Unresolved)', 'Zero-Padded FFT (Leakage/Costly)', ...
       'Proposed CZT Zoom (Resolved)', 'Location', 'Best');

