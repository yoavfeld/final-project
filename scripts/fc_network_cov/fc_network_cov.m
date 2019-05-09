% resting state data script

path_wb_command = '/Applications/workbench/bin_macosx64/wb_command';
data_path = [pwd '/../parcellate/rest_parcellated'];
output_dir = 'output';
path_inner = '';
numOfNetworks = 12;

%specific_net_idx = -1 ; % 9 is dmn. put -1 for all brain. if
%specific_net_idx is not defined, the script create 12 cov files for all
%networks

sub_names=dir(data_path);
sub_vec = {sub_names(3:(end),1).name};
n = length(sub_vec);
%n =2; %debug

index_to_sub_id_map = zeros(n,1);

stratTime = tic;

% Load subjecta files
sub_files = {'gifti'};
for i=1:n
    % Load subject file
    sub_file_path = fullfile(data_path,sub_vec(i), path_inner);
    sub_files{i} = ciftiopen(string(sub_file_path),path_wb_command);
end

for net_idx=1:numOfNetworks
    if exist('specific_net_idx','var') == 1
        net_idx = specific_net_idx;
    end
    
    net_parcel_indexes = get_net_parcells(net_idx);
    global_matrix = zeros(length(net_parcel_indexes)^2, n);
    
    for i=1:n
        sub_file = sub_files{i};
        
        if i==1
            num_of_points = size(sub_file.cdata, 1);
            res = zeros(1, num_of_points);
        end
        
        % Calculate correlation:
        sub = zscore(sub_file.cdata, 0, 2); % zscore is needed? // E: do dim 2
        network = sub(net_parcel_indexes, :); %109*900
        network_corr =  network*network'; % 109x109
        
        % Flatting and inserting to gloabl matrix
        network_corr_flat = reshape(network_corr, [1, length(network_corr)^2]);
        global_matrix(:,i) = network_corr_flat;
    end
    
    %dlmwrite('indexToSubId.txt', index_to_sub_id_map, 'precision', 10)
    cov = corrcoef(global_matrix);
    cov_file_name = strcat(output_dir, '/' ,'fc_rest_net_' ,string(net_idx) ,'_cov.mat');
    save(cov_file_name, 'cov');
    
    if exist('specific_net_idx','var') == 1
        break
    end
end
toc(stratTime)

% display cov with threshold
%th = 0.88;

%indices = find(abs(cov) < th);
%c = cov;
%c(indices) = 0;
%figure; imagesc(c); colorbar


