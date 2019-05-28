
num_of_networks = 13;
%corr_mtx_path = [pwd, '/../fc_network_cov/output_dist/7T_rest1_splited_4/'];
corr_mtx_path = [pwd, '/../../../backup/output_corr/7T_rest1_splited_4/'];
cov_files_prefix = 'fc_7T_rest1_cov_net_';
%corr_mtx_path = [pwd, '/../fc_network_cov/output/3T_rest1_LR_splited_4/'];
%cov_files_prefix = 'fc_3T_rest1_LR_cov_net_';

trues_total = {};
for n=1:num_of_networks
    net_cov_files_path_prefix = strcat(corr_mtx_path, cov_files_prefix, string(n), "_*");
    files = dir(net_cov_files_path_prefix);
    [trues, falses, err_rate] = twins_pred(files, corr_mtx_path);
    %[trues, falses, err_rate] = twins_pred_zygocity(files, corr_mtx_path);
    trues_total = [trues_total trues];
end
bar(cell2mat(trues_total));

