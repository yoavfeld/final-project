% get array of pairs of suspected twins
function [twins] = get_twins_indexes_count(cov, th, count, from)
% cov - correlation matrix
% th - correlation threshold
% count - number of highest correlations to take
% from - from which high correlation to start
% example: highest corr: [1,0.9,0.8,0.7,0.6] th=0.65 count=3 from =2 - take 0.8,0.7

    n = size(cov,1);
    t = 1;
    twins = [];
    ignore = [0 0]; % for calc 1 row per twins
    for s=1:n
        
        %sorting the correlations
        [sorted,originalpos] = sort(abs(cov(s,:)), 'descend' ); % ask e about abs
        maxex_v = sorted(from+1:from+count);
        maxex_i =originalpos(from+1:from+count);
        
        for j=1:size(maxex_i,2)
            m = maxex_v(j);
            i = maxex_i(j);
            
            % prevent repeats
            if max(ismember(ignore(:,1), i)) == 1 && max(ismember(ignore(:,2), s)) == 1
                continue
            end                       
            
            % check th
            if m > th
                twins = [twins;[s i]];
                ignore = [ignore; [s i]];
            end
        end
    end
end