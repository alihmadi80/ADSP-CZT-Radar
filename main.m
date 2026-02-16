% =========================================================================
% MASTER SCRIPT: main.m 
% Project: High-Resolution Spectral Zooming for Radar Sensing using CZT
% Author: Ali Ahmadi
% Course: Advanced Digital Signal Processing (ADSP)
% Description: This script sequentially runs all experiments to reproduce 
%              Figures 1 to 4 and Table I from the conference paper.
% =========================================================================

clc; clear; close all;

fprintf('======================================================\n');
fprintf('  Reproducing Results for ADSP Final Project\n');
fprintf('  High-Resolution Spectral Zooming (CZT)\n');
fprintf('======================================================\n\n');

% Set fixed random seed for global reproducibility
rng('default'); 

%% Experiment 1: Spectral Resolution (Fig. 1)
fprintf('[1/4] Running Experiment 1: High-Resolution Target Separation...\n');
% Calls the script that compares standard FFT, Zero-Padded FFT, and CZT
main_benchmark; 
fprintf('      -> Experiment 1 completed. (Figure 1 generated)\n\n');
pause(1); % Pause to allow figure rendering

%% Experiment 2: Execution Time & Complexity (Fig. 2)
fprintf('[2/4] Running Experiment 2: Hardware Complexity and FLOPs...\n');
% Calls the script that sweeps zoom factors and plots execution time
exp2_complexity;
fprintf('      -> Experiment 2 completed. (Figure 2 generated)\n\n');
pause(1);

%% Experiment 3: Ablation Study (Fig. 3)
fprintf('[3/4] Running Experiment 3: Windowing Ablation Study...\n');
% Calls the script demonstrating the effect of the Kaiser window on leakage
exp3_ablation_window;
fprintf('      -> Experiment 3 completed. (Figure 3 generated)\n\n');
pause(1);

%% Experiment 4: Monte Carlo Robustness (Fig. 4)
fprintf('[4/4] Running Experiment 4: Robustness to Noise (Monte Carlo)...\n');
% Calls the Monte Carlo simulation for RMSE vs. SNR
exp4_rmse_snr;
fprintf('      -> Experiment 4 completed. (Figure 4 generated)\n\n');

fprintf('======================================================\n');
fprintf('  All experiments successfully reproduced!\n');

fprintf('======================================================\n');
