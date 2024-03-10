function createPlots(resultsFolderPath, trnError, valError, model, valFis, trnData)
    % Check if the results folder exists, if not, create it
    if ~exist(resultsFolderPath, 'dir')
       mkdir(resultsFolderPath)
    end

    % Plot and save the learning curve, MFs before and after training
    plotLearningCurve(trnError, valError, resultsFolderPath);
    plotMFs(model, trnData, 'MFs before training', resultsFolderPath, 'MFs_before_training.png')
    plotMFs(valFis, trnData, 'MFs after training', resultsFolderPath, 'MFs_after_training.png')
end

function plotLearningCurve(trnError, valError, resultsFolderPath)
    figure();
    plot(1:length(trnError), trnError, 1:length(valError), valError);
    title('Learning Curve');
    xlabel('Number of Iterations'); 
    ylabel('Error');
    legend('Training Error', 'Validation Error');
    saveas(gcf, fullfile(resultsFolderPath, 'Learning Curve.png'));
end

function plotMFs(model, trnData, title, resultsFolderPath, fileName)
    figure();
    % Change it to 6 for the final classifier
    % for i=1:6
    for i=1:size(trnData, 2) - 1
        subplot(3,2,i);
        plotmf(model,'input',i); 
        grid on;
    end

    sgtitle(title);
    saveas(gcf, fullfile(resultsFolderPath, fileName));
end
