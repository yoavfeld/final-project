path_wb_command = '/Applications/workbench/bin_macosx64/wb_command';
data_path = [pwd '/../data/parcellated'];
path_subjects = [data_path '/subj'];
path_avg_mat = [data_path '/avg'];
path_inner = '';

sub_names=dir(path_subjects);
sub_vec = {sub_names(3:(end),1).name};
n = length(sub_vec);
%n =2; %debug

parts_start_tr = [20,284,525,735,818];
parts_end_tr = [264,505,715,798,901];
tic
for part=1:length(parts_end_tr)
    startTR = parts_start_tr(part);
    endTR = parts_end_tr(part);
    
    for i=1:n
        % Load subject file + other subjects avg file
        sub_file_path = fullfile(path_subjects,sub_vec(i), path_inner);
        avg_file_path = fullfile(path_avg_mat,strcat('A',num2str(i), '.ptseries.nii'));
        sub_file = ciftiopen(string(sub_file_path),path_wb_command);
        avg_file = ciftiopen(string(avg_file_path),path_wb_command);

        if i==1
            num_of_points = size(sub_file.cdata, 1);
            res = zeros(num_of_points, num_of_points);
        end
           
        % Calculate correlation:
        sub = zscore(sub_file.cdata(:,startTR:endTR)');
        avg = zscore(avg_file.cdata(:,startTR:endTR)');
        %samples = endTR-startTR+1;
        res = res + (sub'*avg);
        
    end
    fprintf('finish movie part %d\n' ,part)
    
    res = res./n;
    nii_file = sub_file;
    nii_file.cdata = res';
    res_file_path = strcat(pwd, '/res_', num2str(part), '.ptseries.nii');
    ciftisavereset(nii_file, res_file_path ,path_wb_command);
end
toc
