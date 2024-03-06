% Protopsaltis Panagiotis 9847
clear; clc; close all;
tic;

% Initialize variables
addpath('../../Project 3/Simple Dataset');
data=readtable('../epileptic_seizure_data.csv');
resultsFolderPath = '../../../results/Project4/GridSeach';
%data=removevars(data,{'Var1'});
data.Var1 = [];
data= table2array(data);
Rs = [0.2 0.4 0.7 1]; % radius values
NumberOfFeatures = [5 10 15 20];
preproc=1;

% Split data
[trnData,chkData,tstData] = split_scale(data,preproc);

% Rank the features
[ranks, ~] = relieff(data(:, 1:end - 1), data(:, end), 100);
    
% Check every case for every parameter possible
rule_grid = zeros(length(NumberOfFeatures), length(Rs));
error_cross_grid = zeros(length(NumberOfFeatures), length(Rs));
error_mse_grid = zeros(length(NumberOfFeatures), length(Rs));
accuracy_grid = zeros(length(NumberOfFeatures), length(Rs));

for f = 1 : length(NumberOfFeatures)
 
    for r = 1 : length(Rs)
        fprintf('\n *** Number of features: %d', NumberOfFeatures(f));
        fprintf('\n *** R value: %d \n', Rs(r));
     
        
        % error in each fold
        c = cvpartition(trnData(:, end), 'KFold', 5);
        error_cross = zeros(c.NumTestSets, 1);
        error_mse = zeros(c.NumTestSets, 1);
        accForEachFold = zeros(c.NumTestSets, 1);
     
        % Generate the FIS
        fprintf('\n *** Generating the FIS\n');
     
        % As input data I give the train_id's that came up with the
        % partitiong and only the most important features

        init_fis = genfis2(trnData(:, ranks(1:NumberOfFeatures(f))), trnData(:, end), Rs(r));
        rule_grid(f, r) = length(init_fis.rule);
        if (rule_grid(f, r) == 1 || rule_grid(f,r) > 100) % if there is only one rule we cannot create a fis, so continue to next values
            continue; % or more than 100, continue, for speed reason
        end
        % 5-fold cross validation
        for i = 1 : c.NumTestSets
            fprintf('\n *** Fold #%d\n', i);
         
            train_id = c.training(i);
            test_id = c.test(i);
         
            % Keep separate
            training_data_x = trnData(train_id, ranks(1:NumberOfFeatures(f)));
            training_data_y = trnData(train_id, end);
         
            validation_data_x = trnData(test_id, ranks(1:NumberOfFeatures(f)));
            validation_data_y = trnData(test_id, end);
         
            % Tune the fis
            fprintf('\n *** Tuning the FIS\n');
         
            anfis_opt = anfisOptions('InitialFIS', init_fis, 'EpochNumber', 50, 'DisplayANumberOfFeaturesISInformation', 0, 'DisplayErrorValues', 0, 'DisplayStepSize', 0, 'DisplayFinalResults', 0, 'ValidationData', [validation_data_x validation_data_y]);
         
            [trn_fis, trainError, stepSize, init_fis, chkError] = anfis([training_data_x training_data_y], anfis_opt);
         
            % Evaluate the fis
            fprintf('\n *** Evaluating the FIS\n');
         
            % No need to specify specific options for this, keep the defaults
            Y = evalfis(chkData(:, ranks(1:NumberOfFeatures(f))), init_fis);
            Y=round(Y);
            
            % CHECK ACCURACY OR EVERY
            diff=chkData(:,end)-Y;
            accForEachFold(i) = (length(diff)-nnz(diff))/length(Y)*100;
            % Calculate the error
            error_mse(i) = sum((Y - chkData(:, end)) .^ 2);
            error_cross(i) = crossentropy(Y,chkData(:, end));
        end
        cvErr = sum(error_mse) / c.NumTestSets;
        error_mse_grid(f, r) = cvErr / length(Y);
        accuracy_grid(f, r) = sum(accForEachFold)/ c.NumTestSets;
        error_cross_grid(f, r) = sum(error_cross)/ c.NumTestSets;
    end
end

%% PLOT THE ERROR
fprintf('The error for diffent values of F and R is: %f \n', error_mse_grid);
% save('error_mse_grid', 'error_mse_grid');

fprintf('The number of rules created for diffent values of F and R is: %f \n', rule_grid);
% save('rule_grid', 'rule_grid');


% Plots
if ~exist(resultsFolderPath, 'dir')
   mkdir(resultsFolderPath)
end

figure;
sgtitle('Error for different number of features and R valuess');

subplot(2,2,1);
bar(error_mse_grid(1,:))
xlabel('R values');
ylabel('Mean Square Error');
xticklabels({'0.2','0.4','0.7','1'});
legend('5 features')

subplot(2,2,2);
bar(error_mse_grid(2,:));
xlabel('R values');
ylabel('Mean Square Error');
xticklabels({'0.2','0.4','0.7','1'});
legend('10 features')

subplot(2,2,3);
bar(error_mse_grid(3,:));
xlabel('R values');
ylabel('Mean Square Error');
xticklabels({'0.2','0.4','0.7','1'});
legend('15 features')

subplot(2,2,4);
bar(error_mse_grid(4,:));
xlabel('R values');
ylabel('Mean Square Error');
xticklabels({'0.2','0.4','0.7','1'});
legend('20 features')
saveas(gcf, fullfile(resultsFolderPath, '1.png'));

figure;
bar3(error_mse_grid);
ylabel('Number of features');
yticklabels({'5','10','15','20'});
xlabel('R values');
xticklabels({'0.2','0.4','0.7','1'});
zlabel('Mean square error');
title('MSE differences with changed features and R');
saveas(gcf, fullfile(resultsFolderPath, '2.png'));

figure;
bar3(error_cross_grid);
ylabel('Number of features');
yticklabels({'5','10','15','20'});
xlabel('R values');
xticklabels({'0.2','0.4','0.7','1'});
zlabel('Mean square error');
title('ERROR differences with changed features and R');
saveas(gcf, fullfile(resultsFolderPath, '3.png'));

figure;
bar3(accuracy_grid);
ylabel('Number of features');
yticklabels({'5','10','15','20'});
xlabel('R values');
xticklabels({'0.2','0.4','0.7','1'});
zlabel('Cross entropy error');
title('Accuracy differences with changed features and R');
saveas(gcf, fullfile(resultsFolderPath, '4.png'));

figure;
bar3(rule_grid);
ylabel('Number of features');
yticklabels({'5','10','15','20'});
xlabel('R values');
xticklabels({'0.2','0.4','0.7','1'});
zlabel('Number of rules created');
title('Rules for features and R');
saveas(gcf, fullfile(resultsFolderPath, '5.png'));

toc

%% Elapsed time is 1310.083562 seconds.