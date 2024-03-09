% Protopsaltis Panagiotis 9847
% Independent Model
clear; clc; close all;
tic;

% Initialize variables
addpath('../../Project 3/Simple Dataset');
data = load('../haberman.data');
preproc = 1;
Rs = [0.2 0.8];
resultsFolderPath = '../../../results/Project4/Model';

for i = 1 : length(Rs)    
    % Split data and train anfis
    [trnData,valData,tstData] = split_scale(data,preproc);
    options = genfisOptions('SubtractiveClustering', 'ClusterInfluenceRange', Rs(i)); 
    model = genfis(trnData(:,1:end-1), trnData(:,end), options, 'constant'); 
    [trnFis,trnError,~,valFis,valError] = anfis(trnData,model,[50 0 0.01 0.9 1.1],[],valData);
    
    % Create the plots
    createPlots([resultsFolderPath, num2str(i+2)], trnError, valError, model, valFis, trnData)

    % Evaluate the model
    evaluateModel(tstData, valFis);
    toc
end

% Model 1
% Overall Accuracy = 0.639344
% Khat = 0.075758 
% Producers Accuracy = 0.875000
% Producers Accuracy = 0.190476
% Users Accuracy = 0.673077 
% Users Accuracy = 0.444444 
% Elapsed time is 8.640590 seconds.

% Model 2
% Overall Accuracy = 0.819672
% Khat = 0.204033 
% Producers Accuracy = 0.827586
% Producers Accuracy = 0.666667
% Users Accuracy = 0.979592 
% Users Accuracy = 0.166667 
% Elapsed time is 3.227081 seconds.
