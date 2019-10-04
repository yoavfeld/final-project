path_general='/Users/yoav.feldman/ML/hcp/grayordinate/isc/';
path_subjects = [path_general '2mm'];
path_avg_mat = [path_general 'avg/'];
path_inner = 'MNINonLinear/Results/tfMRI_MOVIE1_7T_AP/tfMRI_MOVIE1_7T_AP_Atlas_MSMAll_hp2000_clean.dtseries.nii';
path_wb_command = '/Applications/workbench/bin_macosx64/wb_command';

out_file_path = [path_general, 'res.nii'];

sub_names=dir(path_subjects);
sub_vec = {sub_names(3:(end),1).name};
n = length(sub_vec);
%n =1; %debug
tic
for i=1:n
    %load subject file + other subjects avg file
    sub_file_path = fullfile(path_subjects,sub_vec(i), path_inner);
    avg_file_path = fullfile(path_avg_mat,strcat('A',num2str(i), '.dtseries.nii'));
    sub_file = ciftiopen(string(sub_file_path),path_wb_command);
    avg_file = ciftiopen(string(avg_file_path),path_wb_command);
    
    if i==1
        num_of_points = size(sub_file.cdata, 1);
        res = zeros(1, num_of_points);
    end
    
    % Calculate correlation:
    %option1 - 1 minute per subject
    for p=1:num_of_points
        res(p) = res(p) + corr(sub_file.cdata(p,:)', avg_file.cdata(p,:)');
    end
    
    %option2 - memory excceeded
    %res = diag(corr(sub_file.cdata', avg_file.cdata'));
    fprintf('finish subject %d\n' ,i)
end
toc
res = res./n;

nii_file = sub_file;
nii_file.cdata = res';

ciftisavereset(nii_file, out_file_path,path_wb_command);
