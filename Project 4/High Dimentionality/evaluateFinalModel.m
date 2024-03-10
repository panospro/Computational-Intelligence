function evaluateFinalModel(tstData, valFis, test_data_x, test_data_y, resultsFolderPath)
    Y = round(evalfis(test_data_x, valFis));
    Y = max(min(Y, 5), 1); % Y values be within [1, 5]
    
    % Error Matrix
    error_matrix = confusionmat(tstData(:,end), Y);
    figure();
    confusionchart(tstData(:,end),Y);
    
    % Producer’s accuracy – User’s accuracy
    N = length(tstData);
    pa = diag(error_matrix) ./ sum(error_matrix, 1)';
    ua = diag(error_matrix) ./ sum(error_matrix, 2);

    % Overall accuracy
    overall_acc = 0;
    for i = 1 : 5
        overall_acc = overall_acc + error_matrix(i, i);
    end
    overall_acc = overall_acc / N;

    % Calculate k
    pe = 0;
    for i = 1:5
        pe = pe + sum(error_matrix(i, :)) * sum(error_matrix(:, i)) / N ^ 2;
    end
    k = (overall_acc - pe) / (1 - pe);

    % Get the metrics
    fprintf('Overall Accuracy = %f \n', overall_acc);
    fprintf('Khat = %f \n', k);
    fprintf('Producers Accuracy = %f \n', pa);
    fprintf('Users Accuracy = %f \n', ua);    
    
    % Plot the real output and estimated output
    figure();
    plot(1:length(test_data_y), test_data_y, 'or', 1:length(test_data_y), Y, '.b');
    title('Results');
    legend('True Outputs', 'Model Outputs');
    saveas(gcf, fullfile(resultsFolderPath, 'results.png'));
end