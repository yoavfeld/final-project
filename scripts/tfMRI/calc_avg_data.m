function [all_avg_data] = calc_avg_data(all_sub_data)
    all_avg_data = {};
    n = length(all_sub_data);
    dims = size(all_sub_data{1});
    for k=1:n
        avg_data = zeros(dims);
        for i=1:n
            if i == k 
                continue
            end
            avg_data = avg_data + all_sub_data{i};
        end
        avg_data = avg_data./(n-1);
        all_avg_data{k} = avg_data;
    end
end