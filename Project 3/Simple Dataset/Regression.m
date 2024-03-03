% Protopsaltis Panagiotis 9847
% Regression with TSK Models
% This script performs regression analysis using TSK fuzzy inference systems.
% It includes data preprocessing, model training with ANFIS, and evaluation.
clear; clc; close all;

% Initialize variables
data = load('../airfoil_self_noise.dat');
preproc = 1;
configs = {2, 'constant'; 3, 'constant'; 2, 'linear'; 3, 'linear'};
epoch = 100;

% Split data
[trnData, valData, tstData] = split_scale(data, preproc);

for i = 1:size(configs, 1)
    tic;
    numMFs = configs{i, 1};
    outputType = configs{i, 2};
    
    % FIS with grid partition
    model_opt = genfisOptions("GridPartition", "NumMembershipFunctions", numMFs, "InputMembershipFunctionType", 'gbellmf', "OutputMembershipFunctionType", outputType);
    inFIS = genfis(trnData(:,1:end-1),trnData(:,end), model_opt);
    
    [trnFis, trnError, ~, valFis, valError] = anfis(trnData, inFIS, [epoch 0 0.01 0.9 1.1], [], valData);

    % Evaluate the valFis model on test data
    Y = evalfis(tstData(:,1:end-1), valFis);
    
    resultsFolderPath = ['../../../results/Project3/Model_', num2str(i)];
    if ~exist(resultsFolderPath, 'dir')
        mkdir(resultsFolderPath);
    end
    
    % Plot MFs, learning curve, and the errors of the model
    plotMFs(inFIS, trnData, valFis, resultsFolderPath);
    plotLearningCurve(trnError, valError, resultsFolderPath);
    plotPredictionErrors(Y, tstData, resultsFolderPath);
    
    % Calculate and print performance metrics
    calculateMetrics(Y, tstData);
    toc;
end