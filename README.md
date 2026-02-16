# High-Resolution Spectral Zooming for Radar Sensing using the Chirp-Z Transform (CZT)

**Course:** Advanced Digital Signal Processing (ADSP) - Final Project  
**Author:** Ali Ahmadi  

## Project Overview
This repository contains the complete MATLAB implementation and reproducible benchmarking suite for the paper *"High-Resolution Spectral Zooming for Radar Sensing using the Chirp-Z Transform."* Modern FMCW radar systems face a "resolution crisis" bounded by the Rayleigh limit. Traditional methods use massive zero-padded FFTs to interpolate the spectrum, leading to exponential $O(N \log N)$ memory and runtime bottlenecks. This project implements a **Chirp-Z Transform (CZT) pipeline** utilizing Bluestein's fast convolution and Kaiser windowing to act as a "spectral microscope." 
We achieve a **42% reduction in execution runtime** and an exact $O(1)$ scaling complexity with zero accuracy loss.

## Prerequisites & Environment
* **MATLAB** (R2021a or newer recommended).
* **Signal Processing Toolbox** is required for windowing (`kaiser`) and noise generation (`awgn`).
* Please see `dependencies.txt` for more details.

## Repository Structure
* `main.m` : **The Master Script.** Runs all experiments sequentially and reproduces all figures.
* `main_benchmark.m` : Generates **Fig. 1** (Spectral Resolution Comparison).
* `exp2_complexity.m` : Generates **Fig. 2** (Execution Time vs. Zoom Factor).
* `exp3_ablation_window.m` : Generates **Fig. 3** (Ablation Study on Spectral Leakage).
* `exp4_rmse_snr.m` : Generates **Fig. 4** (Monte Carlo Simulation for RMSE vs. SNR).
* `czt_radar_zoom.m` : Helper function implementing the core CZT algorithm.
* `signal_gen.m` : Helper function for generating synthetic multi-target FMCW beat signals.

## Exact Run Instructions (Reproducibility)
To strictly reproduce the results, plots, and tables presented in the conference paper, follow these steps:

1. Clone this repository to your local machine:
   ```bash

   git clone [https://github.com/alihmadi80/ADSP-CZT-Radar.git](https://github.com/alihmadi80/ADSP-CZT-Radar.git)
