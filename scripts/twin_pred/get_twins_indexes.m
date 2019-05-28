function [twins] = get_twins_indexes(cov_files_path, cov_files ,th, count, from)
    twins = [];
    cov_matrices = {'gifti'};
    for i=1:length(cov_files)
        % Load subject file  
        corr_mat_file = cov_files(i);      
        load([cov_files_path '/' corr_mat_file.name], 'cov');
        cov_matrices{i} = cov;
    end
    cov = [];
    same_person_failures = 0;
    numOfSubjects = length(cov_matrices{1})
    for s=1:numOfSubjects
        pred_vector = zeros(numOfSubjects, 1);
        for f=1:length(cov_matrices)
            cov = cov_matrices{f};
            
            [sorted,originalpos] = sort((cov(s,:)), 'descend' );
            maxes_v = sorted(from+1:from+count); %get the max corrs after 1
            maxes_i =originalpos(from+1:from+count); %get their original indexes
        
            for j=1:size(maxes_i,2)
                m = maxes_v(j);
                i = maxes_i(j);
                
                if i == s
                    same_person_failures = same_person_failure + 1;   
                end
                
                if m > th && i ~= s
                    pred_vector(i) = pred_vector(i) + 1;
                    %if startsWith(cov_files(f).name , "fc_7T_rest1_cov_net_13") == 1
                    %    pred_vector(i) = pred_vector(i) + 1;
                    %end
                end
            end
        end
        [best_v,best_i] = max(pred_vector);
        %best_v
        if best_v > 1
            twins = [twins;[s best_i]];
        end
    end
    same_person_failures
end
