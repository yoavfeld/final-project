function [trues,falses,err_rate] = twins_pred(varargin)
    
    if length(varargin) > 1
        cov_files = varargin{1};
        corr_mtx_path = varargin{2};
    else
        clear
        corr_mtx_path = [pwd, '/../fc_network_cov/output_dist/7T_rest1/'];
        %corr_mtx_path = [pwd, '/../fc_network_cov/output/3T_rest1_LR_splited_4/'];
        cov_files = dir([corr_mtx_path, '*.mat']);
    end
    
    labels_file = '/Users/yoav.feldman/fmri/final-project/behavior_tests/RESTRICTED_yoavf_4_18_2019_10_37_3.csv';
    sub_names_file = strcat(corr_mtx_path, 'fileNames.txt');
    labels = Labels(labels_file, sub_names_file);
    
    th = 0; % threshold of corr values
    count = 1; % how many highest correlations to take from each subject
    from = 1; % from which highest correlation to star
    
    %DEBUG: random lables
    %famils = labels(:,3);
    %labels(:,3) = famils(randperm(length(famils)));
    
    %fprintf("num of cov files: %d", length(cov_files));
    twins_indexes_pred = get_twins_indexes(corr_mtx_path, cov_files, th, count, from);
    n = size(twins_indexes_pred,1);

    trues = 0;
    falses = 0;
    for t=1:n
        twins_p = twins_indexes_pred(t, :);
        bro1_p = twins_p(1);
        bro2_p = twins_p(2);
        
        % check if one of them is not twin
        if labels.zygosity(bro1_p) == 'NotTwin' || labels.zygosity(bro2_p) == 'NotTwin'
            falses = falses+1;
            continue
        end
        
        %check if same family
        if labels.family(bro1_p) == labels.family(bro2_p)
            trues = trues + 1;
            continue
        end
        falses = falses+1;
    end
    
    falses;
    trues;
    err_rate = falses/(trues+falses);
end

