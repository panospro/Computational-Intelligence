function evaluateModel(tstData, valFis)
    Y = round(evalfis(tstData(:,1:end-1), valFis));
    Y = max(min(Y, 2), 1); % Y values be within [1, 2]

    % Error Matrix
    errorMatrix = confusionmat(tstData(:,end), Y);
    figure();
    confusionchart(tstData(:,end),Y);

    [overallAccuracy, producersAccuracy, usersAccuracy, kHat] = calculateMetrics(errorMatrix);

    % Display results
    fprintf('Overall Accuracy = %f \n', overallAccuracy);
    fprintf('Khat = %f \n', kHat);
    fprintf('Producers Accuracy = %f \n', producersAccuracy);
    fprintf('User Accuracy = %f \n', usersAccuracy);
end

% Function to calculate performance metrics
function [overallAccuracy, producersAccuracy, usersAccuracy, kHat] = calculateMetrics(errorMatrix)
    N = sum(errorMatrix, 'all');
    overallAccuracy = sum(diag(errorMatrix)) / N;

    producersAccuracy = diag(errorMatrix)' ./ sum(errorMatrix, 1)
    usersAccuracy = diag(errorMatrix)' ./ sum(errorMatrix, 2)'

    p1 = sum(errorMatrix(1, :)) * sum(errorMatrix(:, 1)) / N ^ 2;
    p2 = sum(errorMatrix(2, :)) * sum(errorMatrix(:, 2)) / N ^ 2;
    pe = p1 + p2;
    kHat = (overallAccuracy - pe) / (1 - pe);
end
