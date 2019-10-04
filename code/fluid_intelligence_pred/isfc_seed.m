% resting state data fc script

clear
path_wb_command = '/Applications/workbench/bin_macosx64/wb_command';
data_path = [pwd '/../parcellate/data/7T_movie2'];
output_dir = 'isfc_seed_data/7T_movie2_hippo/';
path_inner = '';
seed_idx = [659,660,661,662]; %deafult 23-26

parts_start_tr = [20,267,545,815];
parts_end_tr = [246,525,795,898];

sub_files=dir(strcat(data_path, "/*.nii"));
sub_files_names = {sub_files.name};
n = length(sub_files_names);
stratTime = tic;

warning('off', 'MATLAB:MKDIR:DirectoryExists');
mkdir(output_dir);

% Load subjects files
sub_dataset = {};
for i=1:n
    % Load subject file
    sub_file_path = fullfile(data_path,sub_files_names(i), path_inner);
    sub_nii = ciftiopen(string(sub_file_path),path_wb_command);
    sub_dataset{i} = sub_nii.cdata;
end
% Prepare avg data
avg_dataset = calc_avg_data(sub_dataset);

for part=1:length(parts_end_tr)
    startTR = parts_start_tr(part);
    endTR = parts_end_tr(part);

    for i=1:length(sub_dataset)
        sub_data = sub_dataset{i};
        avg_data = avg_dataset{i};

        if i==1
            num_of_points = length(sub_part);
            res = zeros(num_of_points, 1);
        end

        % Calculate sfc sead based and add it to res:
        sub_part = zscore(sub_data(:,startTR:endTR), 0, 2); %get specific part and do zscore
        avg_part = zscore(avg_data(:,startTR:endTR), 0, 2); %get specific part and do zscore
        
        seed_regions = sub_part(seed_idx,:); %calc avarage to all regions in seed_idx
        seed = mean(seed_regions,1); %1x227 (when 227 is num or TRs)
        res = res + (1/(endTR-startTR))*(avg_part*seed'); %(718x227)*(227x1)
    end

    res = res./n;
    nii_file = sub_nii;
    nii_file.cdata = res;
    res_file_path = strcat(output_dir, '/isfc_seed_avg_part_', num2str(part), '.ptseries.nii');
    ciftisavereset(nii_file, res_file_path ,path_wb_command);
end
toc(stratTime)

