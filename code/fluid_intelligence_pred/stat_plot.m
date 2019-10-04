function [p] = stat_plot(data, alpha, acc, xLabel,yLabel, titl) %(X, y, comp)
    [N,edges] = histcounts(data, 'Normalization','pdf');
    edges = edges(2:end) - (edges(2)-edges(1))/2;
    p = plot(edges, N, 'k', 'LineWidth', 1.5);
    
    pr = prctile(data, (1-alpha)*100)
    line([pr,pr], [0,max(ylim())], 'Color','red', 'LineStyle', '--', 'LineWidth', 1.5);
    line([acc,acc], [0,max(ylim())], 'Color','blue', 'LineWidth', 2);
    title(titl);
    legend('Shuffled Accuracies',strcat('\alpha=',string(alpha)),'UnShuffled Accuracy', 'Location', 'northwest');
    xlabel(xLabel);
    ylabel(yLabel);
end