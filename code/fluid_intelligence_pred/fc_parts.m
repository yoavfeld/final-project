% resting state data fc script

clear
path_wb_command = '/Applications/workbench/bin_macosx64/wb_command';
data_path = [pwd '/../parcellate/data/7T_movie3'];
output_dir = 'fc_data/fc_7T_movie3';
path_inner = '';
numOfNetworks = 13;
net_whitelist = [5,9,13]; %if empty, run on all networks

parts_start_tr = [20,220,425,649,811];
parts_end_tr = [200,405,629,792,895];

sub_names=dir(strcat(data_path, "/*.nii"));
sub_vec = {sub_names.name};
n = length(sub_vec);
%n =2; %debug

stratTime = tic;

% Load subjects files
warning('off', 'MATLAB:MKDIR:DirectoryExists');
mkdir(output_dir);
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
    if ~isempty(net_whitelist) && ~ismember(net_idx, net_whitelist)
        continue
    end
    
    if net_idx < 13 
        net_parcel_indexes = get_net_parcells(net_idx);
    else
        net_parcel_indexes = get_net_parcells(-1); % network 13 = all brain
    end
    
    for part=1:length(parts_end_tr)
        startTR = parts_start_tr(part);
        endTR = parts_end_tr(part);

        for i=1:n
            sub_file = sub_files{i};

            % Calculate correlation:
            sub = zscore(sub_file.cdata(:,startTR:endTR), 0, 2); % zscore is needed? // E: do dim 2
            network = sub(net_parcel_indexes, :); %109*900
            network_corr =  network*network'; % 109x109
            network_corr = network_corr./(endTR-startTR); % devide by T-1
            % remove half of the fc using triu or tril

            file_path = strcat(output_dir, "/net_", string(net_idx),"/part_",string(part) ,"/");
            file_name = strcat('sub_', extractBetween(sub_vec(i),1,6), '.nii.mat');
            mkdir(file_path);
            save(strcat(file_path, file_name) ,'network_corr');
        end
    end
end
toc(stratTime)



% th = 0.85;
% indices = find(abs(cov) < th);
% c = cov;
% c(indices) = 0;
% figure; imagesc(c); colorbar


