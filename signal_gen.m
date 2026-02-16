function [x, t] = signal_gen(Fs, N, f1, f2, snr_db)
    % SIGNAL_GEN: Generates two closely spaced sinusoidal targets + AWGN
    % Fs: Sampling frequency
    % N: Number of samples
    % f1, f2: Frequencies of the two targets
    % snr_db: Signal-to-Noise Ratio
    
    t = (0:N-1)' / Fs;
    
    % Generate composite signal (Target 1 + Target 2 with slightly different amplitudes)
    s = exp(1j * 2 * pi * f1 * t) + 0.8 * exp(1j * 2 * pi * f2 * t);
    
    % Add Additive White Gaussian Noise
    x = awgn(s, snr_db, 'measured');
end