function [twins] = get_twins_indexes(corrMtxPath, numOfSubjects ,th, count, from)
    files = dir(strcat(corrMtxPath, '/*.mat'));
    twins = [];
    best_net_vector = zeros(numOfSubjects, 1);
    
%     cov_files = {'gifti'};
%     for i=1:len(files)
%         % Load subject file
%         sub_file_path = fullfile(data_path,sub_vec(i), path_inner);
%         sub_files{i} = ciftiopen(string(sub_file_path),path_wb_command);
%     end
    
    for s=1:numOfSubjects
        pred_vector = zeros(numOfSubjects, 1);
        
        for f=1:length(files)
            corr_mat_file = files(f);
            [~,~,ext] = fileparts(corr_mat_file.name);
            if ext ~= ".mat"
                continue;
            end
            
            load([corrMtxPath '/' corr_mat_file.name], 'cov');
            [sorted,originalpos] = sort(abs(cov(s,:)), 'descend' ); % ask e about abs
            
            maxes_v = sorted(from+1:from+count); %get the max corrs after 1
            maxes_i =originalpos(from+1:from+count); %get their original indexes
        
            for j=1:size(maxes_i,2)
                m = maxes_v(j);
                i = maxes_i(j);

                if m > th
                    pred_vector(i) = pred_vector(i) + 1;
                    if startsWith(corr_mat_file.name, "fc_rest_net_13") == 1
                        %pred_vector(i) = pred_vector(i) + 1;
                        best_net_vector(s) = i;
                    end
                end
            end
        end
        [best_v,best_i] = max(pred_vector);
        %best_v
        if best_v > 1   
            twins = [twins;[s best_i]];
        else if best_v > 0
            twins = [twins;[s best_net_vector(s)]];
        end
    end
end