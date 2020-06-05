%% Candidate functions and Pre-Processsing
% This function contains the candidate features and the the pre-processing
% treatments.

function [f, feat_names] = feature_list(data)

%% Pre-Processing
% The pre-processing stage was discarted as not every feature benefits from
% the normalization and HPF. These are being handled individualy in the
% feature_list.m function. The commented lines contain part of the proposed
% treatmetnt.

% data = data-repmat(mean(data), size(data,1), 1);    
% data = data ./ repmat(std(data), size(data,1), 1);
 
% features = highpass(features, 0.01, 96, 'Steepness', 0.95);
freq = fft(data);

%% Candidate Features
% The array f contains the candiate features. Please make sure that the
% feat_names array has the same length as f. The current list contains the
% optimized feature set as described in the report.

feat_names = ["|FFT| f>3", "STD", "Median", "MAD", "Skewness"];
f = [rms(abs(freq(3:end))) ...
     std(data) ...
     median(data) ...
     mad(data) ...
     skewness(data) ...
     ];
 assert(length(f) == length(feat_names), 'Different array lenghts! feat_names != f')