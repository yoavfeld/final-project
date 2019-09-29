function networks_bar(data, titl, xLabel, yLabel, sortData)
    labels = {'Primary Visual', 'Secondary Visual', 'Somatomotor', 'Cingulo-Opercular', 'Dorsal-attention', 'Language', 'Frontoparietal', 'Auditory', 'Default', 'Posterior Multimodal', 'Ventral Multimodal', 'Orbito-Affective', 'All Brain'};
    if sortData == true 
        [sorted, orgPos] = sort(data);
        bar(sorted);
        set(gca, 'XTickLabel',labels(orgPos), 'XTick',1:numel(labels));
        text(1:length(sorted),sorted,num2str(sorted'),'vert','bottom','horiz','center'); 
    else
        bar(data);
        set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels));
        text(1:length(data),data,num2str(data'),'vert','bottom','horiz','center'); 
    end
    title(titl);
    ylabel(yLabel);
    xlabel(xLabel);
    xtickangle(45);
    
end