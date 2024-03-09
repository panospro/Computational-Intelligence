% Protopsaltis Panagiotis 9847
% Dependent model
clear; clc; close all;
tic;

% Initialize variables
addpath('../../Project 3/Simple Dataset');
data = load('../haberman.data');
Acc = zeros(2,1);
preproc = 1;
Rs = [0.2 0.8];

for i = 1:length(Rs)
    resultsFolderPath = ['../../../results/Project4/Model', num2str(i + 2)];

    % Split data
    [trnData, chkData, tstData] = split_scale(data,preproc);
    
    %%Clustering Per Class
    [c1,sig1] = subclust(trnData(trnData(:,end)==1,:),Rs(i));
    [c2,sig2] = subclust(trnData(trnData(:,end)==2,:),Rs(i));
    num_rules = size(c1,1)+size(c2,1);
    
    %Build FIS From Scratch
    fis = newfis('FIS_SC','sugeno');
    
    %Add Input-Output Variables
    names_in = {'in1','in2','in3'};
    for i=1:size(trnData,2)-1
        fis = addInput(fis, [0 1], 'Name', names_in{i});
    end
    fis=addOutput(fis, [0 1], 'Name', 'out1');
    
    %Add Input Membership Functions
    for i=1:size(trnData,2)-1
        input = strcat('in', string(i));
        for j=1:size(c1,1)
            fis = addMF(fis, input, 'gaussmf', [sig1(i) c1(j,i)]);
        end
        for j=1:size(c2,1)
            fis = addMF(fis, input, 'gaussmf', [sig2(i) c2(j,i)]);
        end
    end
    
    %Add Output Membership Functions
    params=[zeros(1,size(c1,1)) ones(1,size(c2,1))];
    for i=1:num_rules
        output = strcat('out', string(1));
        fis=addMF(fis, output, 'constant', params(i));
    end
    
    %Add FIS Rule Base
    ruleList=zeros(num_rules,size(trnData,2));
    for i=1:size(ruleList,1)
        ruleList(i,:) = i;
    end
    ruleList = [ruleList ones(num_rules,2)];
    fis = addrule(fis,ruleList);
    
    anfisOpt = anfisOptions('InitialFIS', fis, 'EpochNumber', 50, 'ValidationData', chkData);
    [trnFis,trnError,~,valFis,valError] = anfis(trnData, anfisOpt);
    
    
    % Create Plots
    createPlots(resultsFolderPath, trnError, valError, fis, valFis, trnData)
    
    %evaluation of model
    Y = evalfis(tstData(:,1:end-1),valFis);
    Y = round(Y);
    
    for i = 1:length(Y)
        if Y(i) > 2
            Y(i) = 2;
        end
        if Y(i) < 1
            Y(i) = 1;
        end
    end
    
    diff = tstData(:,end)-Y;
    Acc = (length(diff)-nnz(diff))/length(Y)*100;
        
    %% Error Matrix
    error_matrix = confusionmat(tstData(:,end), Y);
    pa = zeros(1, 2);
    ua = zeros(1, 2);
    %% confusion matrix 
    figure();
    cm = confusionchart(tstData(:,end),Y);
        
    %% Producer’s accuracy – User’s accuracy
    N = length(tstData);
    for i = 1 : 2
        pa(i) = error_matrix(i, i) / sum(error_matrix(:, i));
        ua(i) = error_matrix(i, i) / sum(error_matrix(i, :));
    end
    
    %% Overall accuracy
    overall_acc = 0;
    for i = 1 : 2
        overall_acc = overall_acc + error_matrix(i, i);
    end
    overall_acc = overall_acc / N;
    
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

% Model 3
% OA = 0.639344, K = 0.107713 
% PA = 0.785714, PA = 0.315789, UA = 0.717391 
% UA = 0.400000 
% Elapsed time is 13.273271 seconds.

% Model 4
% OA = 0.770492, K = 0.284757 
% PA = 0.807692, PA = 0.555556, UA = 0.913043 
% UA = 0.333333 
% Elapsed time is 3.594349 seconds.