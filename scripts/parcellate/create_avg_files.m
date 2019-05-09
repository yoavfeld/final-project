
path_subjects = [pwd '/movie_parcellated/sub/'];
path_inner = ''; %'MNINonLinear/Results/tfMRI_MOVIE1_7T_AP/tfMRI_MOVIE1_7T_AP_Atlas_MSMAll_hp2000_clean.dtseries.nii';
path_avg = [pwd '/movie_parcellated/avg/'];
file_ext = '.ptseries.nii';
path_wb_command = '/Applications/workbench/bin_macosx64/wb_command';
dims = [718,921];

sub_names=dir(path_subjects);
sub_vec = {sub_names(3:(end),1).name};
n = length(sub_vec);

for k=1:n
    avg_data = zeros(dims);
    for i=1:n
        if i == k 
            continue
        end
        file_path = fullfile(path_subjects,sub_vec(i), path_inner);
        nii_file = ciftiopen(string(file_path),path_wb_command);
        avg_data = avg_data + nii_file.cdata;
    end
    avg_data = avg_data./(n-1);
    nii_file.cdata = avg_data;
    file_path = [path_avg 'A' num2str(k) file_ext];
    ciftisave(nii_file, file_path,path_wb_command, 1);
end
fprintf('finish \n')



