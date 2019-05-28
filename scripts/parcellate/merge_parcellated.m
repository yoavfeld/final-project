

clear
path_wb_command = '/Applications/workbench/bin_macosx64/wb_command';
data_path = [pwd '/../parcellate/data/'];
folders_prefix = "7T_rest*";
output_dir = 'data/7T_merged_rest/';

scans_directories=dir(strcat(data_path,folders_prefix));
sub_file_names = dir(strcat(data_path, scans_directories(1).name, '/*.nii'));

for i=1:length(sub_file_names)
    
    sub_merged_mat = [];
    for d=1:length(scans_directories)
        folder_name = scans_directories(d).name;
        sub_file_names = dir(strcat(data_path, folder_name, '/*.nii'));
        sub_file_path = fullfile(data_path,folder_name,sub_file_names(i).name);
        sub_file = ciftiopen(string(sub_file_path),path_wb_command);
        sub_merged_mat = [sub_merged_mat, sub_file.cdata];
    end
    cov_file_name = strcat(output_dir,'merged_',sub_file_names(i).name);
    sub_file.cdata = sub_merged_mat;
    ciftisave(sub_file, cov_file_name, path_wb_command);
    %save(cov_file_name, 'sub_merged_mat');
end

    