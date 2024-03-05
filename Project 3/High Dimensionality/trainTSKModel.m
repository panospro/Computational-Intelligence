function [init_fis, valFis, trainError, valError] = trainTSKModel(training_data_x, training_data_y, validation_data_x, validation_data_y, R)
    options = genfisOptions('SubtractiveClustering', 'ClusterInfluenceRange', R);
    init_fis = genfis(training_data_x, training_data_y, options);
    anfis_opt = anfisOptions('InitialFIS', init_fis, 'EpochNumber', 150, 'ValidationData', [validation_data_x validation_data_y], 'DisplayANFISInformation', 0, 'DisplayErrorValues', 0, 'DisplayStepSize', 0, 'DisplayFinalResults', 0);
    [~, trainError, ~, valFis, valError] = anfis([training_data_x training_data_y], anfis_opt);
end