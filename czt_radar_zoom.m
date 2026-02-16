function [f_czt, X_czt] = czt_radar_zoom(x, Fs, f_start, f_end, M, beta)
    % CZT_RADAR_ZOOM: High-resolution spectral zooming using CZT and Kaiser Window
    % M: Number of output points
    % beta: Kaiser window parameter (controls spectral leakage)
    
    N = length(x);
    
    % Apply Kaiser Window to the time-domain signal
    win = kaiser(N, beta);
    x_win = x .* win;
    
    % Define the CZT contour parameters
    W = exp(-1j * 2 * pi * (f_end - f_start) / (M * Fs));
    A = exp(1j * 2 * pi * f_start / Fs);
    
    % Execute Chirp-Z Transform (internally uses Bluestein's fast convolution O(N log N))
    X_czt = czt(x_win, M, W, A);
    
    % Generate the exact frequency vector for the zoomed region
    f_czt = linspace(f_start, f_end, M);
end