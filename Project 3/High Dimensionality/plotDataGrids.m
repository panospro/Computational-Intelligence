function plotDataGrids(grid, plotType, titleText, labels, fileName, resultsFolderPath)
    figure();

    switch plotType
        case '2D'
            for i = 1:4
                subplot(2, 2, i);
                bar(grid(i, :));
                xlabel('R');
                ylabel('Mean Square Error');
                xticklabels(labels.r);
                legend([labels.features{i} ' features']);
            end

        case '3D'
            bar3(grid);
            ylabel('Number of features');
            yticklabels(labels.features);
            xlabel('R');
            xticklabels(labels.r);
            zlabel(labels.zlabel);
    end

    title(titleText);
    saveas(gcf, fullfile(resultsFolderPath, fileName));
    close(gcf);
end