function analyzeResults(init_fis, valFis, trainError, valError, test_data_x, test_data_y, resultsFolderPath)
    % Evaluate the fis and calculate the error
    Y = evalfis(test_data_x, valFis);
    error = Y - test_data_y;

    if ~exist(resultsFolderPath, 'dir')
       mkdir(resultsFolderPath)
    end
    
    % Plots of MFs, Learning curve, prediction errors and model vs real
    % outputs. Then calculate the results for the metrics.
    plotMembershipFunctions(init_fis, 'Membership Functions Before Training', resultsFolderPath, 'MF_Before.png');
    plotMembershipFunctions(valFis, 'Membership Functions After Training', resultsFolderPath, 'MF_After.png');
    plotLearningCurve(trainError, valError, resultsFolderPath, 'Learning Curve.png')
    plotPredictionErrors(error, resultsFolderPath, 'Prediction_errors.png')
    plotOutputDif(Y, test_data_y, resultsFolderPath, 'OutputDif.png')  
    calculateMetrics(Y, test_data_y);
end

function plotMembershipFunctions(fis, titleText, resultsFolderPath, fileName)
    figure();
    for i = 1:length(fis.Inputs)
        subplot(5, 4, i);
        plotmf(fis, 'input', i);
        grid on;
    end
    sgtitle(titleText);
    ylabel('Degree of membership');
    saveas(gcf, fullfile(resultsFolderPath, fileName));
end

function plotLearningCurve(trainError, valError, resultsFolderPath, fileName)
    figure();
    plot(1:length(trainError), trainError, 1:length(valError), valError);
    legend('Training Error', 'Validation Error');
    title('Learning Curve');
    saveas(gcf, fullfile(resultsFolderPath, fileName));
end

function plotPredictionErrors(error, resultsFolderPath, fileName)
    figure();
    plot(error);
    title('Prediction Errors');
    saveas(gcf, fullfile(resultsFolderPath, fileName));
end

function plotOutputDif(Y, test_data_y, resultsFolderPath, fileName)
    figure();
    plot(1:length(test_data_y), test_data_y, 1:length(test_data_y), Y);
    title('Difference between real and estimated output');
    legend('Actual Output', 'TSK Output');
    saveas(gcf, fullfile(resultsFolderPath, fileName));
end

function calculateMetrics(Y, test_data_y)
    Rsq = @(ypred, y) 1 - sum((ypred-y) .^ 2) / sum((y - mean(y)) .^2);
    R2=Rsq(Y, test_data_y);
    MSE=mse(Y, test_data_y);
    RMSE=sqrt(MSE);
    NMSE=sum((test_data_y - Y) .^ 2) / (length(Y) * var(test_data_y));
    NDEI=sqrt(NMSE);
    
    fprintf('RMSE = %f MSE = %f R^2 = %f NMSE = %f NDEI = %f\n', RMSE, MSE, R2, NMSE, NDEI)
end