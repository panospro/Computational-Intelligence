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
    plotMFs(inFIS, trnData, valFis, resultsFolderPath, i);
    plotLearningCurve(trnError, valError, resultsFolderPath, i);
    plotPredictionErrors(Y, tstData, resultsFolderPath, i);
    
    % Calculate and print performance metrics
    calculateMetrics(Y, tstData);
    toc;
end

% Model 1
% R^2 = 0.703208 RMSE = 3.777705  NMSE = 0.295806 NDEI = 0.543880
% Elapsed time is 6.973319 seconds.

% Model 2
% R^2 = 0.821727 RMSE = 2.711864  NMSE = 0.177680 NDEI = 0.421521
% Elapsed time is 46.501204 seconds

% Model 3
% R^2 = 0.781977 RMSE = 3.161286  NMSE = 0.217299 NDEI = 0.466153
% Elapsed time is 15.052684 seconds.

% Model 4
% R^2 = 0.691035 RMSE = 3.884325  NMSE = 0.307938 NDEI = 0.554922
% Elapsed time is 1106.885042 seconds.