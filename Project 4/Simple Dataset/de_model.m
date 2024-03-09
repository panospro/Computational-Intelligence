% Protopsaltis Panagiotis 9847
% Dependent model
clear; clc; close all;
tic;

% Initialize variables
addpath('../../Project 3/Simple Dataset');
data = load('../haberman.data');
preproc = 1;
Rs = [0.2 0.8];
resultsFolderPath = '../../../results/Project4/Model';

for i = 1:length(Rs)
    % Split data
    [trnData, chkData, tstData] = split_scale(data, preproc);
    
    % Clustering per Class
    [c1, sig1] = subclust(trnData(trnData(:, end)==1, :), Rs(i));
    [c2, sig2] = subclust(trnData(trnData(:, end)==2, :), Rs(i));
    num_rules = size(c1, 1)+size(c2, 1);

    % Train the fis
    fis = trainFis(trnData, c1, sig1, c2, sig2, num_rules);

    % Train anfis
    anfisOpt = anfisOptions('InitialFIS', fis, 'EpochNumber', 50, 'ValidationData', chkData);
    [~, trnError, ~, valFis, valError] = anfis(trnData, anfisOpt);
    
    % Create Plots
    createPlots([resultsFolderPath, num2str(i + 2)], trnError, valError, fis, valFis, trnData)
    
    % Evaluate the model
    evaluateModel(tstData, valFis);

    toc
end

% Model 3
% Overall Accuracy = 0.639344
% Khat = 0.107713 
% Producers Accuracy = 0.785714
% Producers Accuracy = 0.315789
% Users Accuracy = 0.717391 
% Users Accuracy = 0.400000 
% Elapsed time is 13.273271 seconds.

% Model 4
% Overall Accuracy = 0.770492
% Khat = 0.284757 
% Producers Accuracy = 0.807692
% Producers Accuracy = 0.555556
% Users Accuracy = 0.913043 
% Users Accuracy = 0.333333 
% Elapsed time is 3.594349 seconds.
