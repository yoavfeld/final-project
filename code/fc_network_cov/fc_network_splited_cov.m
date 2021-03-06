% resting state data fc script

clear
path_wb_command = '/Applications/workbench/bin_macosx64/wb_command';
data_path = [pwd '/../parcellate/data/7T_rest2_181'];
output_dir = 'output_corr/7T_rest2_181_splited_4';
out_files_prefix = 'fc_7T_rest2_cov_net_';
path_inner = '';
numOfNetworks = 13;
split = 4;

%specific_net_idx = 9 ; % 9 is dmn. put -1 for all brain. if
%specific_net_idx is not defined, the script create 12 cov files for all
%networks

sub_names=dir(strcat(data_path, "/*.nii"));
sub_vec = {sub_names.name};
n = length(sub_vec);
%n =2; %debug

stratTime = tic;

% Load subjects files
sub_names_file = fopen([output_dir '/fileNames.txt'],'w');
sub_files = {'gifti'};
for i=1:n
    % Load subject file
    sub_file_path = fullfile(data_path,sub_vec(i), path_inner);
    sub_files{i} = ciftiopen(string(sub_file_path),path_wb_command);
    sub_name = cell2mat(extractBefore(sub_vec(i),7));
    fprintf(sub_names_file,'%s\n', sub_name);
end
fclose(sub_names_file);

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
    % length will be >= 4
    networkSplit = split;
    while length(net_parcel_indexes) < 4*networkSplit
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

        cov = corrcoef(global_matrix);
        %cov = ipdm(global_matrix');
        if length(find(cov==1)) ~= length(cov)
            fprintf("skip bad cov matrix. num of ones: %d \n", length(find(cov==1)));
        else
            cov_file_name = strcat(output_dir, '/' ,out_files_prefix ,string(net_idx), '_rest_', string(sn_idx) ,'.mat');
            save(cov_file_name, 'cov');
        end
        if exist('specific_net_idx','var') == 1
            break
        end
    end
end
toc(stratTime)
