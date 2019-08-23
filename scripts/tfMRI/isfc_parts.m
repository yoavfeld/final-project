% resting state data fc script

clear
path_wb_command = '/Applications/workbench/bin_macosx64/wb_command';
data_path = [pwd '/../parcellate/data/7T_movie3'];
output_dir = 'isfc_data/isfc_7T_movie3/';
path_inner = '';
numOfNetworks = 13;
net_whitelist = [5,9,13]; %if empty, run on all networks

parts_start_tr = [20,220,425,649,811];
parts_end_tr = [200,405,629,792,895];

sub_files=dir(strcat(data_path, "/*.nii"));
sub_files_names = {sub_files.name};
n = length(sub_files_names);
stratTime = tic;

warning('off', 'MATLAB:MKDIR:DirectoryExists');
mkdir(output_dir);

% Load subjects files
dataset = {};
for i=1:n
    % Load subject file
    sub_file_path = fullfile(data_path,sub_files_names(i), path_inner);
    sub_nii = ciftiopen(string(sub_file_path),path_wb_command);
    dataset{i} = sub_nii.cdata;
end

% Devide data to train and test
dataset_chunks = {};
dataset_chunks{1} = dataset(1:130);
dataset_chunks{2} = dataset(131:length(dataset));
sub_files_names_chunks = {};
sub_files_names_chunks{1} = sub_files_names(1:130);
sub_files_names_chunks{2} = sub_files_names(131:length(dataset));
chunks = {'train', 'test'};

for c=1:length(chunks)
    sub_data_chunk = dataset_chunks{c};
    sub_names_chunks = sub_files_names_chunks{c};
    % Prepare avg data
    avg_data_chunk = calc_avg_data(sub_data_chunk);

    % create isfc matrix for each network
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

            for i=1:length(sub_data_chunk)
                sub_data = sub_data_chunk{i};
                avg_data = avg_data_chunk{i};

                % Calculate correlation:
                sub_part = zscore(sub_data(:,startTR:endTR), 0, 2); %get specific part and do zscore
                sub_part_net = sub_part(net_parcel_indexes, :); %get only parcels of network (109*900)

                avg_part = zscore(avg_data(:,startTR:endTR), 0, 2); %get specific part and do zscore
                avg_part_net = avg_part(net_parcel_indexes, :); %get only parcels of network (109*900)

                network_isfc = sub_part_net*avg_part_net';
                network_isfc = network_isfc./(endTR-startTR); % devide by T-1

                % Save isfc file
                file_path = strcat(output_dir, chunks{c}, "/net_", string(net_idx),"/part_",string(part) ,"/");
                mkdir(file_path);
                file_name = strcat('sub_', extractBetween(sub_names_chunks(i),1,6), '.nii.mat');
                %file_name = strcat('sub_', string(i), '.mat');
                save(strcat(file_path, file_name) ,'network_isfc');
            end
        end
    end
end
toc(stratTime)

