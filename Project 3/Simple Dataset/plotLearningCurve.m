function plotLearningCurve(trnError, valError, resultsFolderPath)
    figure();
    plot([trnError valError], 'LineWidth', 2); 
    grid on;
    xlabel('Number of Iterations'); 
    ylabel('Error');
    legend('Training Error', 'Validation Error');
    title('Learning Curve');
    saveas(gcf, fullfile(resultsFolderPath, 'Learning_Curve.png'))
    close(gcf);
end