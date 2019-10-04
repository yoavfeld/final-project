% resting state data fc script

clear
path_wb_command = '/Applications/workbench/bin_macosx64/wb_command';
data_path = [pwd '/../parcellate/data/7T_movie1'];
output_dir = 'isc_data/isc_7T_movie1/';
path_inner = '';

parts_start_tr = [20,284,525,735,818];
parts_end_tr = [264,505,715,798,901];

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

% Prepare avg dataset
avg_dataset = calc_avg_data(dataset);

for part=1:length(parts_end_tr)
    startTR = parts_start_tr(part);
    endTR = parts_end_tr(part);

    for i=1:n
        sub_data = dataset{i};
        avg_data = avg_dataset{i};

        % Calculate correlation:
        sub_part = zscore(sub_data(:,startTR:endTR), 0, 2); %get specific part and do zscore
        avg_part = zscore(avg_data(:,startTR:endTR), 0, 2); %get specific part and do zscore
        
        if i==1
            num_of_points = length(sub_part);
            res = zeros(1,num_of_points);
        end
        res = res + (1/(endTR-startTR))*sum(sub_part'.*avg_part');
       
    end
    res = res./n;
    res_file_path = strcat(output_dir, '/isc_part_', num2str(part), '.ptseries.nii');
    nii_file = sub_nii;
    nii_file.cdata = res';
    ciftisavereset(nii_file, res_file_path ,path_wb_command);
end
toc(stratTime)

