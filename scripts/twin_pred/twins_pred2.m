
% covMtxFiles=dir('/home/michael/localrepo/final-project/final-project/scripts/twin_pred/cov_mtx/*.mat');
covMtxFiles=dir('/Users/yoav.feldman/fmri/final-project/scripts/twin_pred/fc_rest_cov/*.mat');
trues_total = zeros(1,length(covMtxFiles));

cnt_vec = [1 5 10];
for cnt_num=1:length(cnt_vec) 
    for k=1:length(covMtxFiles)
        covMtxFileNames=covMtxFiles(k).name
        corr_file = strcat('fc_rest_cov/', covMtxFileNames);
        
        labels_file = '7t_labels.mat';
        th      = 0 ; % threshold of corr values
        count   = cnt_vec(cnt_num) ;% how many highest correlations to take from each subject
        from    = 1 ;% from which highest correlation to start
        load(corr_file);
        load(labels_file);
        
        twins_indexes_pred = get_twins_indexes_count(cov, th, count, from);
        
        n = size(twins_indexes_pred,1);
        
        trues = 0;
        falses = 0;
        
        for t=1:n
            twins_p = twins_indexes_pred(t, :);
            bro1_p = twins_p(1);
            bro2_p = twins_p(2);
            
            % check if one of them is not twin
            if labels(bro1_p, 2) == 0 || labels(bro2_p, 2) == 0
                falses = falses+1;
                continue
            end
            
            %check if same family
            if labels(bro1_p, 3) == labels(bro2_p, 3)
                trues = trues + 1;
                continue
            end
            falses = falses+1;
        end
        %TODO:export to excel file|name|trues|false
        trues_total(k)=trues;
    end
    subplot(length(cnt_vec),1,cnt_num);
    bar(trues_total);
    title(['number of counts = ',num2str(cnt_vec(cnt_num))]);

end
saveas(gcf,'total_trues_isfc.jpg')