function calculateMetrics(Y, tstData)
    Rsq = @(ypred, y) 1 - sum((ypred - y) .^ 2) / sum((y - mean(y)) .^ 2);
    R2 = Rsq(Y, tstData(:, end));
    RMSE = sqrt(mse(Y, tstData(:, end)));
    NMSE = sum((tstData(:, end) - Y) .^ 2) / (length(Y) * var(tstData(:, end)));
    NDEI = sqrt(NMSE);
    fprintf('R^2 = %f RMSE = %f  NMSE = %f NDEI = %f\n', R2, RMSE, NMSE, NDEI)
end