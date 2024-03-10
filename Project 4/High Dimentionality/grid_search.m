% Protopsaltis Panagiotis 9847
clear; clc; close all;
tic;

% Initialize variables
resultsFolderPath = '../../../results/Project4/GridSeach';
addpath('../../Project 3/Simple Dataset');
data=readtable('../epileptic_seizure_data.csv');
data.Var1 = [];
data= table2array(data);
Rs = [0.2 0.4 0.6 1]; % radius values
NumberOfFeatures = [5 10 15 20];
preproc=1;

% Split data
[trnData,chkData,tstData] = split_scale(data,preproc);

% Rank the features
[ranks, ~] = relieff(data(:, 1:end - 1), data(:, end), 100);

rule_grid = zeros(length(NumberOfFeatures), length(Rs));
error_cross_grid = zeros(length(NumberOfFeatures), length(Rs));
error_mse_grid = zeros(length(NumberOfFeatures), length(Rs));
accuracy_grid = zeros(length(NumberOfFeatures), length(Rs));

for f = 1 : length(NumberOfFeatures)
    for r = 1 : length(Rs)
        fprintf('\n Features: %d \n \n R: %d \n', NumberOfFeatures(f), Rs(r));

        % Cross validation
        c = cvpartition(trnData(:, end), 'KFold', 5);
        errorCross = zeros(c.NumTestSets, 1);
        errorMse = zeros(c.NumTestSets, 1);
        foldAccuracy = zeros(c.NumTestSets, 1);

        % Train fis
        init_fis = genfis2(trnData(:, ranks(1:NumberOfFeatures(f))), trnData(:, end), Rs(r));
        rule_grid(f, r) = length(init_fis.rule);

        if (rule_grid(f,r) > 100)
            continue;
        end

        % 5-fold cross validation
        for i = 1 : c.NumTestSets
            fprintf('\n Number of fold %d\n', i);

            train_id = c.training(i);
            test_id = c.test(i);

            % Split data
            training_data_x = trnData(train_id, ranks(1:NumberOfFeatures(f)));
            training_data_y = trnData(train_id, end);
            validation_data_x = trnData(test_id, ranks(1:NumberOfFeatures(f)));
            validation_data_y = trnData(test_id, end);

            % Train anfis
            anfis_opt = anfisOptions('InitialFIS', init_fis, 'EpochNumber', 50, 'ValidationData', [validation_data_x validation_data_y]);
            [trn_fis, trainError, stepSize, init_fis, chkError] = anfis([training_data_x training_data_y], anfis_opt);

            % Calculate output
            Y = evalfis(chkData(:, ranks(1:NumberOfFeatures(f))), init_fis);
            Y=round(Y);
            diff=chkData(:,end)-Y;
            foldAccuracy(i) = (length(diff)-nnz(diff))/length(Y)*100;
            errorMse(i) = sum((Y - chkData(:, end)) .^ 2);
            errorCross(i) = crossentropy(Y,chkData(:, end));
        end
        cvErr = sum(errorMse) / c.NumTestSets;
        error_mse_grid(f, r) = cvErr / length(Y);
        accuracy_grid(f, r) = sum(foldAccuracy)/ c.NumTestSets;
        error_cross_grid(f, r) = sum(errorCross)/ c.NumTestSets;
    end
end

% Plots
if ~exist(resultsFolderPath, 'dir')
   mkdir(resultsFolderPath)
end

R_values = {'0.2', '0.4', '0.6', '1'};
featureCounts = {'5', '10', '15', '20'};

% 3rd and 4th are useless diagrams ??
grids = {error_mse_grid, error_mse_grid, error_cross_grid, accuracy_grid, rule_grid};
titles = {'Error', ...
          'MSE', ...
          'Error', ...
          'Accuracy', ...
          'Rules'};
ylabels = {'Mean Square Error', 'Mean square error', 'Mean square error', 'Cross entropy error', 'Number of rules created'};
fileNames = {'1.png', '2.png', '3.png', '4.png', '5.png'};

% Generate plots for each grid
for i = 1:length(grids)
    grid = grids{i};
    if i == 1
        figure;
        sgtitle(titles{i});
        for j = 1:4
            subplot(2,2,j);
            bar(grid(j,:));
            xlabel('R values');
            ylabel(ylabels{i});
            xticklabels(R_values);
            legend([featureCounts{j}, ' features']);
        end
    else
        figure;
        bar3(grid);
        ylabel('Number of features');
        yticklabels(featureCounts);
        xlabel('R values');
        xticklabels(R_values);
        zlabel(ylabels{i});
        title(titles{i});
    end
    saveas(gcf, fullfile(resultsFolderPath, fileNames{i}));
end
toc

% Elapsed time is 817.996942 seconds.