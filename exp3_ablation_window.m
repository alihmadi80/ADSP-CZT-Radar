% =========================================================================
% Experiment 3: Ablation Study - The Effect of Windowing on Spectral Leakage
% =========================================================================
clear; clc;
rng('default');

Fs = 1e6;       
N = 256;        
t = (0:N-1)' / Fs;

% Strong Target at 100 kHz (0 dB)
% Weak Target at 115 kHz (-25 dB)
s = 1.0 * exp(1j * 2 * pi * 100e3 * t) + 0.056 * exp(1j * 2 * pi * 115e3 * t);
x = awgn(s, 20, 'measured');

M_czt = 512;          
f_start = 85e3;       % بازه را وسیع‌تر کردیم تا حاشیه امن داشته باشیم
f_end = 130e3;        

% 1. CZT WITHOUT Window (Rectangular / No suppression)
[f_czt_rect, X_czt_rect] = czt_radar_zoom(x, Fs, f_start, f_end, M_czt, 0); 

% 2. CZT WITH Kaiser Window (beta = 8 for high dynamic range)
[f_czt_kaiser, X_czt_kaiser] = czt_radar_zoom(x, Fs, f_start, f_end, M_czt, 8);

% Convert to dB
Mag_rect = 20*log10(abs(X_czt_rect));
Mag_kaiser = 20*log10(abs(X_czt_kaiser));

% Plotting
figure('Position', [200, 200, 800, 400]);
plot(f_czt_rect/1e3, Mag_rect - max(Mag_rect), 'k--', 'LineWidth', 1.5); hold on;
plot(f_czt_kaiser/1e3, Mag_kaiser - max(Mag_kaiser), 'r', 'LineWidth', 2);
grid on;
ylim([-80, 5]);
xlim([85, 130]); % گستره نمایش بزرگتر شد
xlabel('Frequency (kHz)');
ylabel('Normalized Magnitude (dB)');
title('Ablation Study: Eliminating Spectral Leakage to Detect a Pedestrian');

% تنظیمات دقیق برای جلوگیری از به هم ریختگی متن‌ها
legend('CZT (No Window) - Leakage masks the weak target', ...
       'CZT (Kaiser Window, \beta=8) - Weak target resolved', 'Location', 'SouthEast');

% رسم خطوط راهنما با لیبل‌های کاملا خوانا در جای درست
xline(100, 'b:', 'Strong Target (Truck)', ...
    'LabelOrientation', 'horizontal', 'LabelHorizontalAlignment', 'center', ...
    'LabelVerticalAlignment', 'bottom', 'FontSize', 10, 'FontWeight', 'bold');
    
xline(115, 'b:', 'Weak Target (Pedestrian)', ...
    'LabelOrientation', 'horizontal', 'LabelHorizontalAlignment', 'center', ...
    'LabelVerticalAlignment', 'bottom', 'FontSize', 10, 'FontWeight', 'bold');

set(gca, 'FontSize', 12);