function [twins] = get_twins_indexes(cov, th)
    n = size(cov,1);
    t = 1;
    twins = [];
    ignore = []; % for calc 1 row per twins
    for s=1:n        
        if max(ismember(ignore, s)) == 1
           continue
        end
                
        [temp,originalpos] = sort( cov(s,:), 'descend' );
        m = temp(2:2);
        i =originalpos(2:2);
        
        if m > th
            twins = [twins;[s i]];
            ignore = [ignore, i];
        end
    end
end