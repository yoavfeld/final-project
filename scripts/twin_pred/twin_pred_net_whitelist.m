
num_of_networks = 13;
corr_mtx_path = [pwd, '/../fc_network_cov/output/7T_rest1_splited_4/'];
cov_files_prefix = 'fc_7T_rest1_cov_net_';   %'fc_rest_net_';
network_white_list = [1,3,5,6,2,4,7,9,13];

files = [];
for n=1:num_of_networks
    if ~ismember(n,network_white_list)
        continue
    end
    fprintf('adding network %d \n', n);
    net_cov_files_path_prefix = strcat(corr_mtx_path, cov_files_prefix, string(n), "_*");
    files = [files;dir(net_cov_files_path_prefix)];
end
fprintf('start prediction by %d cov failes \n', length(files));
twins_pred(files, corr_mtx_path);
%bar(cell2mat(trues_total));

