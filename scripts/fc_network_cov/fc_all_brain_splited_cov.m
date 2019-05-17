% resting state data fc script

path_wb_command = '/Applications/workbench/bin_macosx64/wb_command';
data_path = [pwd '/../parcellate/rest_parcellated'];
output_dir = 'rest_all_brain_splited';
path_inner = '';

cov_len = 4;
parcells = 718;
chunks = floor(parcells/cov_len);

sub_names=dir(data_path);
sub_vec = {sub_names(3:(end),1).name};
n = length(sub_vec);
%n =2; %debug

stratTime = tic;

% Load subjects files
sub_files = {'gifti'};
for i=1:n
    % Load subject file
    sub_file_path = fullfile(data_path,sub_vec(i), path_inner);
    sub_files{i} = ciftiopen(string(sub_file_path),path_wb_command);
end

sub_nets = {};
for ch=1:chunks
    start_idx = (ch-1)*cov_len+1;
    end_idx = start_idx + cov_len - 1;
    sub_nets = [sub_nets; [start_idx:end_idx]];
end

if parcells > end_idx
    last_chunk = sub_nets{chunks};
    last_chunk = [last_chunk [end_idx+1:parcells]];
    sub_nets(chunks) = mat2cell(last_chunk,1, length(last_chunk));
end

for sn_idx=1:length(sub_nets)
    sub_net = sub_nets{sn_idx};
    global_matrix = zeros(length(sub_net)^2, n);

    for i=1:n
        sub_file = sub_files{i};

        if i==1
            num_of_points = size(sub_file.cdata, 1);
            res = zeros(1, num_of_points);
        end

        % Calculate correlation:
        sub = zscore(sub_file.cdata, 0, 2); % zscore is needed? // E: do dim 2
        network = sub(sub_net, :); %109*900
        network_corr =  network*network'; % 109x109

        % Flatting and inserting to gloabl matrix
        network_corr_flat = reshape(network_corr, [1, length(network_corr)^2]);
        global_matrix(:,i) = network_corr_flat;
    end

    cov = corrcoef(global_matrix);
    cov_file_name = strcat(output_dir, '/' ,'fc_rest_chunk_' ,string(sn_idx) ,'_cov.mat');
    save(cov_file_name, 'cov');
    
end
    
toc(stratTime)
