function plotMFs(Model, trnData, valFis, resultsFolderPath)
    plotAndSaveMFs(Model, 'before training', trnData, resultsFolderPath);
    plotAndSaveMFs(valFis, 'after training', trnData, resultsFolderPath);
end

function plotAndSaveMFs(fis, titleName, trnData, resultsFolderPath)
    figure();
    k = size(trnData, 2) - 1;
    for i = 1:k
        subplot(3, 2, i);
        plotmf(fis, 'input', i);
        grid on;
    end
    sgtitle(['MFs ', titleName]);
    saveFigurePath = fullfile(resultsFolderPath, ['MFs_', titleName, '.png']);
    saveas(gcf, saveFigurePath);
    close(gcf);
end