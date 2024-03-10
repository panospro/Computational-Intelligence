% Protopsaltis Panagiotis 9847
clear; clc; close all;
tic;

% Initialize variables
addpath('../../Project 3/Simple Dataset');
addpath('../../Project 4/Simple Dataset');
data = readtable('../epileptic_seizure_data.csv');
resultsFolderPath = '../../../results/Project4/Final_Model';
data.Var1 = [];
data = table2array(data);
R = 0.2;
NumberOfFeatures = 15;
preproc = 1;

% Split data
[trnData,chkData,tstData] = split_scale(data,preproc);
[ranks, ~] = relieff(data(:,1:end-1), data(:, end), 100);

trnDataX = trnData(:,ranks(1:NumberOfFeatures));
trnDataY = trnData(:,end);

valDataX = chkData(:,ranks(1:NumberOfFeatures));
valDataY = chkData(:,end);

testDataX = tstData(:,ranks(1:NumberOfFeatures));
testDataY = tstData(:,end);

% Train model
model = genfis2(trnDataX, trnDataY, R);
rules = length(model.rule);
anfis_opt = anfisOptions('InitialFIS', model, 'EpochNumber', 150, 'DisplayANFISInformation', 0, 'DisplayErrorValues', 0, 'DisplayStepSize', 0, 'DisplayFinalResults', 0, 'ValidationData', [valDataX valDataY]);
[trnFis,trnError,~,valFis,valError] = anfis([trnDataX trnDataY], anfis_opt);

% Plots
createPlots(resultsFolderPath, trnError, valError, model, valFis, trnData);

% Evaluate the fis
evaluateFinalModel(tstData, valFis, testDataX, testDataY, resultsFolderPath);

toc

% Overall Accuracy = 0.419130 
% Khat = 0.274852 
% Producers Accuracy = 0.896985 
% Producers Accuracy = 0.265625 
% Producers Accuracy = 0.346609 
% Producers Accuracy = 0.304619 
% Producers Accuracy = 0.159091 
% Users Accuracy = 0.804054 
% Users Accuracy = 0.071730 
% Users Accuracy = 0.685106 
% Users Accuracy = 0.545861 
% Users Accuracy = 0.015054 
% Elapsed time is 2232.014802 seconds.