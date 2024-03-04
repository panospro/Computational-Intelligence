% Protopsaltis Panagiotis 9847
clear; clc; close all;
tic;

% Initialize variables
addpath('../Simple Dataset');
resultsFolderPath = '../../../results/Project3/Grid_search';
data=load('../superconduct.csv');
preproc = 1;
Rs = [0.2 0.4 0.7 1]; % radius values
NumberOfFeatures = [5 10 15 20];
rules = zeros(length(NumberOfFeatures), length(Rs));
errors = zeros(length(NumberOfFeatures), length(Rs));
labels.r = arrayfun(@(x) num2str(x), Rs, 'UniformOutput', false);
labels.features = arrayfun(@(x) num2str(x), NumberOfFeatures, 'UniformOutput', false);
labels.zlabel = 'Number of rules created';
titles = {
    'Error for different number of features and r values in 2D', ...
    'Error for different number of features and r values in 3D', ...
    'Rules created for different number of features and r'
};

% Split data and keep only the features we want
[tData, cData , ~] = split_scale(data, preproc);
[ranks, weights] = relieff(data(:, 1:end - 1), data(:, end), 100);

for f = 1:length(NumberOfFeatures)
        for r = 1:length(Rs)
            [ruleCount, cvpErr] = performCrossValidation(tData, ranks, NumberOfFeatures(f), Rs(r), cData);

            if isempty(ruleCount) || isempty(cvpErr)
                continue;
            end

            rules(f, r) = ruleCount;
            errors(f, r) = cvpErr;
        end
end

% Create the plots
if ~exist(resultsFolderPath, 'dir')
   mkdir(resultsFolderPath)
end

plotDataGrids(errors, '2D', titles{1}, labels, 'd.png', resultsFolderPath);
plotDataGrids(errors, '3D', titles{2}, labels, 'e.png', resultsFolderPath);
plotDataGrids(rules, '3D', titles{3}, labels, 'f.png', resultsFolderPath);

toc;

% Elapsed time 14 hours.