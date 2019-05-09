path_wb_command = '/Applications/workbench/bin_macosx64/wb_command';
data_path = [pwd '/../data/parcellated'];
path_subjects = [data_path '/subj'];
path_inner = '';
seed_idx = 34; %default_41

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
        % Load subject file
        sub_file_path = fullfile(path_subjects,sub_vec(i), path_inner);
        sub_file = ciftiopen(string(sub_file_path),path_wb_command);
        
        if i==1
            num_of_points = size(sub_file.cdata, 1);
            res = zeros(1, num_of_points);
        end

        % Calculate correlation:
        sub = zscore(sub_file.cdata(:,startTR:endTR)');
        seed = sub(:,seed_idx);
        samples = endTR-startTR+1;
        res = res + (1/(samples-1))*sum(seed.*sub);
        
    end
    fprintf('finish movie part %d\n' ,part)
    
    res = res./n;
    nii_file = sub_file;
    nii_file.cdata = res';
    res_file_path = strcat(pwd, '/res_', num2str(part), '.ptseries.nii');
    ciftisavereset(nii_file, res_file_path ,path_wb_command);
end
toc
