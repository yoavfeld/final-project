% resting state data fc script

path_wb_command = '/Applications/workbench/bin_macosx64/wb_command';
data_path = [pwd '/../parcellate/7T/rest2'];
output_dir = '7T_rest2_splited';
out_files_prefix = 'fc_7T_rest2_cov_net_';
path_inner = '';
numOfNetworks = 12;
split = 16;

%specific_net_idx = 9 ; % 9 is dmn. put -1 for all brain. if
%specific_net_idx is not defined, the script create 12 cov files for all
%networks

sub_names=dir(data_path);
sub_vec = {sub_names(3:(end),1).name};
n = length(sub_vec);
%n =2; %debug

stratTime = tic;

% Load subjects files
sub_files = {'gifti'};
for i=1:n
    % Load subject file
    sub_file_path = fullfile(data_path,sub_vec(i), path_inner);
    sub_files{i} = ciftiopen(string(sub_file_path),path_wb_command);
end

% create cov matrix for each network
for net_idx=1:numOfNetworks
    if exist('specific_net_idx','var') == 1
        net_idx = specific_net_idx;
    end
    
    if net_idx < 13 
        net_parcel_indexes = get_net_parcells(net_idx);
    else
        net_parcel_indexes = get_net_parcells(-1); % network 13 = all brain
    end
     
    % calc the maximum split size for the current network that each chunk
    % length will be >= 2
    networkSplit = split;
    while length(net_parcel_indexes) < 2*networkSplit
        networkSplit = networkSplit-1;
    end
    
    sub_nets = splitArray(net_parcel_indexes, networkSplit);
    
    for sn_idx=1:length(sub_nets)
        sub_net = cell2mat(sub_nets(sn_idx));
        global_matrix = zeros(length(sub_net)^2, n);

        for i=1:n
            sub_file = sub_files{i};

            if i==1
                num_of_points = size(sub_file.cdata, 1);
                res = zeros(1, num_of_points);
            end

            % Calculate correlation:
            sub = zscore(sub_file.cdata, 0, 2); % zscore is needed? // E: do dim 2
            network = sub(sub_net, :); %109*900
            network_corr =  network*network'; % 109x109

            % Flatting and inserting to gloabl matrix
            network_corr_flat = reshape(network_corr, [1, length(network_corr)^2]);
            global_matrix(:,i) = network_corr_flat;
        end

        %dlmwrite('indexToSubId.txt', index_to_sub_id_map, 'precision', 10)
        cov = corrcoef(global_matrix);
        cov_file_name = strcat(output_dir, '/' ,out_files_prefix ,string(net_idx), '_', string(sn_idx) ,'.mat');
        save(cov_file_name, 'cov');

        if exist('specific_net_idx','var') == 1
            break
        end
    end
end
toc(stratTime)
