function plotLearningCurve(trnError, valError, resultsFolderPath, i)
    figure();
    plot([trnError valError], 'LineWidth', 2); 
    grid on;
    xlabel('Number of Iterations'); 
    ylabel('Error');
    legend('Training Error', 'Validation Error');
    title('Learning Curve');
    saveas(gcf, fullfile(resultsFolderPath, [num2str(i), '_Learning_Curve.png']))
    close(gcf);
end