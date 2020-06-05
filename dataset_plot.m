%% Dataset Visualizer
% This script inserts all the experiments in the dataset to the Singnal
% Analyzer app. The same sintax is recommended to open the signal analyzer
% with the desired signals, as storing them all in the app's workspace
% feels slow. The Classes.mldatx file already has the workspace with all
% signals disabled.

load('dataset_usb_hci_dtc.mat');
dataset = dataset_usb_hci_guided_dtc;

for s = 1:24
    triUp(:, s) = cell2mat(dataset{s}{1})';
end
for s = 1:24
    square(:, s) = cell2mat(dataset{s}{2})';
end
for s = 1:24
    circle(:, s) = cell2mat(dataset{s}{3})';
end
for s = 1:24
    infinite(:, s) = cell2mat(dataset{s}{4})';
end
for s = 1:24
    triDwn(:, s) = cell2mat(dataset{s}{5})';
end

signalAnalyzer(triUp, square, circle, infinite, triDwn)
