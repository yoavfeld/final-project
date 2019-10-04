
num_of_networks = 13;
corr_mtx_path = [pwd, '/../fc_network_cov/output_corr/7T_rest1_182_splited_4/'];
%corr_mtx_path = [pwd, '/../../../backup/output_corr/7T_rest1_splited_4/'];
cov_files_prefix = 'fc_7T_rest1_cov_net_'; 

% all scans together cov matrices
%corr_mtx_path = [pwd, '/../fc_network_cov/output_corr/7T_merged_rest/'];
%cov_files_prefix = 'fc_7T_mergerd_rest_cov_net_';

%3T
%corr_mtx_path = [pwd, '/../fc_network_cov/output/3T_rest1_LR_splited_4/'];
%cov_files_prefix = 'fc_3T_rest1_LR_cov_net_';

network_white_list = [1,3,5,6,2,4,7,9,13];

files = [];
for n=1:num_of_networks
    if ~ismember(n,network_white_list)
        continue
    end
    net_cov_files_path_prefix = strcat(corr_mtx_path, cov_files_prefix, string(n), "_*");
    f = dir(net_cov_files_path_prefix);
    files = [files;f];
end

fprintf('start all twins prediction...');
[trues, falses, ~] = twins_pred(files, corr_mtx_path)

fprintf('start MZ twins prediction...');
[trues, falses, ~] = twins_pred_zygocity(files, corr_mtx_path)


