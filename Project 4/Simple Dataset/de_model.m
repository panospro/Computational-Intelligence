% Protopsaltis Panagiotis 9847
% Dependent model
clear; clc; close all;
tic;

% Initialize variables
addpath('../../Project 3/Simple Dataset');
data = load('../haberman.data');
preproc = 1;
Rs = [0.2 0.8];
resultsFolderPath = '../../../results/Project5/Model';

for i = 1:length(Rs)
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
    for i = 1:size(trnData,2)-1
        fis = addInput(fis, [0 1], 'Name', names_in{i});
    end
    fis = addOutput(fis, [0 1], 'Name', 'out1');
    
    %Add Input Membership Functions
    for i = 1:size(trnData,2)-1
        input = strcat('in', string(i));
        for j = 1:size(c1,1)
            fis = addMF(fis, input, 'gaussmf', [sig1(i) c1(j,i)]);
        end
        for j = 1:size(c2,1)
            fis = addMF(fis, input, 'gaussmf', [sig2(i) c2(j,i)]);
        end
    end
    
    %Add Output Membership Functions
    params = [zeros(1,size(c1,1)) ones(1,size(c2,1))];
    for i = 1:num_rules
        output = strcat('out', string(1));
        fis = addMF(fis, output, 'constant', params(i));
    end
    
    %Add FIS Rule Base
    ruleList = zeros(num_rules,size(trnData,2));
    for i = 1:size(ruleList,1)
        ruleList(i,:) = i;
    end
    ruleList = [ruleList ones(num_rules,2)];
    fis = addrule(fis,ruleList);
    
    anfisOpt = anfisOptions('InitialFIS', fis, 'EpochNumber', 50, 'ValidationData', chkData);
    [trnFis,trnError,~,valFis,valError] = anfis(trnData, anfisOpt);
    
    
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
