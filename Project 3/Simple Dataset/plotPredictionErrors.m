function plotPredictionErrors(Y, tstData, resultsFolderPath)
    figure();
    error = Y - tstData(:, end);
    plot(error);
    title('Prediction Errors');
    saveas(gcf, fullfile(resultsFolderPath, 'Prediction_errors.png'))
    close(gcf);
end