function plotPredictionErrors(Y, tstData, resultsFolderPath, i)
    figure();
    error = Y - tstData(:, end);
    plot(error);
    title('Prediction Errors');
    saveas(gcf, fullfile(resultsFolderPath, [num2str(i), '_Prediction_errors.png']))
    close(gcf);
end