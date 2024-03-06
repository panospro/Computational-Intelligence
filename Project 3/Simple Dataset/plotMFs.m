function plotMFs(Model, trnData, valFis, resultsFolderPath, i)
    plotAndSaveMFs(Model, 'before training', trnData, resultsFolderPath, i);
    plotAndSaveMFs(valFis, 'after training', trnData, resultsFolderPath, i);
end

function plotAndSaveMFs(fis, titleName, trnData, resultsFolderPath, numberOfModel)
    figure();
    k = size(trnData, 2) - 1;
    for i = 1:k
        subplot(3, 2, i);
        plotmf(fis, 'input', i);
        grid on;
    end
    sgtitle(['MFs ', titleName]);
    saveFigurePath = fullfile(resultsFolderPath, [num2str(numberOfModel), '_MFs_', titleName, '.png']);
    saveas(gcf, saveFigurePath);
    close(gcf);
end