% Protopsaltis Panagiotis 9847
% Regression with TSK models using UCI Superconductivity dataset
clear; clc; close all; tic;

% clearvars -except ranks weights

% Initialize variables
data=load('../superconduct.csv');
preproc=1;
NOF = 20;
R = 0.4;
resultsFolderPath = '../../../results/Project3/Task2';
addpath('../Simple Dataset');

% Split data and keep only the features we want
[trnData,chkData,tstData]=split_scale(data, preproc);

[ranks, ~] = relieff(data(:,1:end-1), data(:, end), 100);

[training_data_x, training_data_y] = deal(trnData(:, ranks(1:NOF)), trnData(:, end));
[validation_data_x, validation_data_y] = deal(chkData(:, ranks(1:NOF)), chkData(:, end));
[test_data_x, test_data_y] = deal(tstData(:, ranks(1:NOF)), tstData(:, end));

% Train tsk model
[init_fis, valFis, trainError, valError] = trainTSKModel(training_data_x, training_data_y, validation_data_x, validation_data_y, R);

% Analyze and plot results
analyzeResults(init_fis, valFis, trainError, valError, test_data_x, test_data_y, resultsFolderPath);
toc;

% RMSE = 13.835028 MSE = 191.407992 R^2 = 0.836962 NMSE = 0.162999 NDEI = 0.403732
% Elapsed time is 880.356354 seconds.
