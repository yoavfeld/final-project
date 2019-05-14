function [twins] = get_twins_indexes(corrMtxPath, numOfSubjects ,th, count, from)
    files = dir(corrMtxPath);
    twins = [];
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
                    if corr_mat_file.name == "fc_rest_net_9_cov.mat"
                        pred_vector(i) = pred_vector(i) + 1;
                    end
                end
            end
        end
        [best_v,best_i] = max(pred_vector);
        %best_v
        if best_v > 1
            twins = [twins;[s best_i]];
        end
    end
end