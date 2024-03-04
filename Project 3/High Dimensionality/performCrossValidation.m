function [ruleCount, cvpErr] = performCrossValidation(trnData, ranks, NumberOfFeatures, R, chkData)
    cvp = cvpartition(trnData(:, end), 'KFold', 5);
    error = zeros(cvp.NumTestSets, 1);

    [init_fis, ruleCount] = generateFIS(trnData, ranks, NumberOfFeatures, R);

    % Skip further processing if FIS is empty
    if isempty(init_fis)
        cvpErr = [];
        return; 
    end

    for i = 1:cvp.NumTestSets
        train_id = cvp.training(i);
        test_id = cvp.test(i);

        training_data = trnData(train_id, [ranks(1:NumberOfFeatures) end]);
        validation_data = trnData(test_id, [ranks(1:NumberOfFeatures) end]);

        anfis_opt = anfisOptions('InitialFIS', init_fis, 'EpochNumber', 50, 'DisplayANFISInformation', 0, 'DisplayErrorValues', 0, 'DisplayStepSize', 0, 'DisplayFinalResults', 0, 'ValidationData', validation_data); 
        [~, ~, ~, init_fis, ~] = anfis(training_data, anfis_opt);
         
        Y = evalfis(chkData(:, ranks(1:NumberOfFeatures)), init_fis);
        error(i) = sum((Y - chkData(:, end)) .^ 2);
    end

    cvpErr = sum(error) / (cvp.NumTestSets * length(Y));
end

% Function that returns empty fis array if rules are 1 or more than 100
function [init_fis, ruleCount] = generateFIS(tData, ranks, NumberOfFeatures, R)
    options = genfisOptions('SubtractiveClustering', 'ClusterInfluenceRange', R);
    init_fis = genfis(tData(:, ranks(1:NumberOfFeatures)), tData(:, end), options);
    ruleCount = length(init_fis.rule);

    if ruleCount == 1 || ruleCount > 100
        init_fis = []; 
        ruleCount = [];
    end
end
