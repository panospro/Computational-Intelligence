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
            sgtitle(titleText);

        case '3D'
            bar3(grid);
            ylabel('Number of features');
            yticklabels(labels.features);
            xlabel('R');
            xticklabels(labels.r);
            
            % Just a patch to not give an extra argument
            if titleText == "Error for different number of features and r values in 3D"
                zlabel('Mean Square Error');
            else
                zlabel(labels.zlabel);
            end
            title(titleText);
    end

    saveas(gcf, fullfile(resultsFolderPath, fileName));
    close(gcf);
end