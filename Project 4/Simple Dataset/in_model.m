% Protopsaltis Panagiotis 9847
% Independent Model
clear; clc; close all;
tic;

% Initialize variables
addpath('../../Project 3/Simple Dataset');
data=load('../haberman.data');
preproc = 1;
Rs = [0.2 0.8];

for i = 1:length(Rs)
    resultsFolderPath = ['../../../results/Project4/Model', num2str(i)]
    
    % Split data and train anfis
    [trnData,valData,tstData] = split_scale(data,preproc);
    options = genfisOptions('SubtractiveClustering', 'ClusterInfluenceRange', Rs(i)); 
    model = genfis(trnData(:,1:end-1), trnData(:,end), options, 'constant'); 
    [trnFis,trnError,~,valFis,valError]=anfis(trnData,model,[50 0 0.01 0.9 1.1],[],valData);
    
    % Create the plots
    createPlots(resultsFolderPath, trnError, valError, model, valFis, trnData)
       
    %% Evaluate the valFis model on test data
    Y=evalfis(tstData(:,1:end-1),valFis);
    Y=round(Y);
    
    for i=1:length(Y)
        if Y(i) > 2
            Y(i) = 2;
        end
        if Y(i) < 1
            Y(i) = 1;
        end
    end
    
    diff=tstData(:,end)-Y;
    Acc=(length(diff)-nnz(diff))/length(Y)*100;
    
    
    %% Error Matrix
    error_matrix = confusionmat(tstData(:,end), Y);
    pa = zeros(1, 2);
    ua = zeros(1, 2);
    
    %% confusion matrix
    figure();
    cm = confusionchart(tstData(:,end),Y);
    
    %% Overall accuracy - OA
    overall_acc = 0;
    N = length(tstData);
    for i = 1 : 2
        overall_acc = overall_acc + error_matrix(i, i);
    end
    overall_acc = overall_acc / N;
    
    
    %% Producer’s accuracy (PA) – User’s accuracy (UA)
    for i = 1 : 2
        pa(i) = error_matrix(i, i) / sum(error_matrix(:, i));
        ua(i) = error_matrix(i, i) / sum(error_matrix(i, :));
    end
    
    
    %% k
    p1 = sum(error_matrix(1, :)) * sum(error_matrix(:, 1)) / N ^ 2;
    p2 = sum(error_matrix(2, :)) * sum(error_matrix(:, 2)) / N ^ 2;
    pe = p1 + p2;
    k = (overall_acc - pe) / (1 - pe);
    
    fprintf('OA = %f, K = %f \n', overall_acc , k);
    fprintf('PA = %f, ', pa);
    fprintf('UA = %f \n', ua);
    toc
end

% Model 1
% OA = 0.639344,  K = 0.075758 
% PA = 0.875000, PA = 0.190476, UA = 0.673077 
% UA = 0.444444 
% Elapsed time is 8.640590 seconds.

% Model 2
% OA = 0.819672, K = 0.204033 
% PA = 0.827586, PA = 0.666667, UA = 0.979592 
% UA = 0.166667 
% Elapsed time is 3.227081 seconds.