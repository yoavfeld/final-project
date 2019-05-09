% movie data script

path_wb_command = '/Applications/workbench/bin_macosx64/wb_command';
data_path = [pwd '/../parcellate/movie_parcellated/sub'];
path_avg_mat = [pwd '/../parcellate/movie_parcellated/avg'];
path_inner = '';

net_idx = 9 ; % 9 is dmn
net_parcel_indexes = get_net_parcells(net_idx); % return 109 parcel indexes of the dmn

sub_names=dir(data_path);
sub_vec = {sub_names(3:(end),1).name};
n = length(sub_vec);
%n =2; %debug
global_matrix = zeros(length(net_parcel_indexes)^2, n);
index_to_sub_id_map = zeros(n,1);

tic
for i=1:n
    % Load subject file
    
    sub_file_path = fullfile(data_path,sub_vec(i), path_inner);
    sub_file = ciftiopen(string(sub_file_path),path_wb_command);
    avg_file_path = fullfile(path_avg_mat,strcat('A',num2str(i), '.ptseries.nii'));
    avg_file = ciftiopen(string(avg_file_path),path_wb_command);
    
    index_to_sub_id_map(i) = strtok(string(sub_vec(i)),'_');

    if i==1
        num_of_points = size(sub_file.cdata, 1);
        res = zeros(1, num_of_points);
    end

    % Calculate correlation: 
    sub = zscore(sub_file.cdata,0,2); % zscore is needed?
    avg = zscore(avg_file.cdata,0,2);
    network_sub = sub(net_parcel_indexes, :); %109*921
    network_avg = avg(net_parcel_indexes, :); %109*921
    network_corr = network_sub*network_avg'; % 109x109

    % Flatting and inserting to gloabl matrix
    network_corr_flat = reshape(network_corr, [1, length(network_corr)^2]);
    global_matrix(:,i) = network_corr_flat;
end
toc

save('indexToSubId.txt', 'index_to_sub_id_map', '-ascii')
cov = corrcoef(global_matrix);
save('iscf_movie1_cov.mat', 'cov');

% display cov with threshold
th = 0.85;
indices = find(abs(cov) < th);
c = cov;
c(indices) = 0;
figure; imagesc(c); colorbar


