clear
path_wb_command = '/Applications/workbench/bin_macosx64/wb_command';
base_data_path = '/Users/yoav.feldman/fmri/final-project/scripts/tfMRI/isfc_data/isfc_7T_movie4/test/';
labels_file = '/Users/yoav.feldman/fmri/final-project/behavior_tests/fluid_inteligence.csv';
%path_wb_command = '/home/michael/workbench/bin_linux64/wb_command';
%data_path = '/home/michael/localrepo/final-project/final-project/scripts/fc_7T_rest1_182/net_13';
%output_dir = '/home/michael/localrepo/final-project/final-project/scripts/sum_of_matrix/output';
%%
data_type = "ISFC" % FC or ISFC
parts = 4;
stratTime = tic;
net_whitelist = [5,9,13]; %if empty, run on all networks

%% Create labels object
data = load_fluidinteligence(labels_file);
labels = Labels('', '', data);

for net=1:13
    if ~isempty(net_whitelist) && ~ismember(net, net_whitelist)
        continue
    end
        
    for p=1:parts
        
        %% Load subjects files
        data_path = strcat(base_data_path, "net_", string(net), "/part_", string(p), "/");     
        file_names_ca=dir(strcat(data_path, "/sub_*"));
        sub_file_names = {file_names_ca.name};
        n = length(sub_file_names);
        sub_files = {};
        for i=1:n
            % Load subject file
            sub_file_path = cell2mat(fullfile(data_path,sub_file_names(i)));
            sub_files{i} = load(sub_file_path);
        end
        
        %% sum matrices
        Y_lin = [];
        Y_9_classes = [];
        X = [];
        
        for i=1:n
            
            sub_file_name = sub_file_names{i};
            sub_id = str2num(sub_file_name(5:10));
            value = labels.fluidIntelligence(sub_id);
            
            if data_type == "FC"
                fc_mtx=sub_files{i}.network_corr;
                %fc_mtx(find(~fc_mtx)) = 0.00000001;
                flat_data = nonzeros(triu(fc_mtx,1)); % keep only upper diagonal
            elseif data_type == "ISFC"
                isfc_mtx=sub_files{i}.network_isfc;
                isfc_sym = (isfc_mtx*isfc_mtx')/2; % make symmetric 
                isfc_sym(find(~isfc_sym)) = 0.00000001; %preventing 0 correlations
                flat_data = nonzeros(triu(isfc_sym,1)); % keep only upper diagonal
            end
            X(i,:) = flat_data;
            Y_lin(i) = value;
            Y_9_classes(i) = floor(value/2); % normalize to 9 classes (3-11)
        end
        save(strcat(data_path, 'Y_lin.mat'),'Y_lin');
        save(strcat(data_path, 'Y_9_classes.mat'),'Y_9_classes');
        save(strcat(data_path, 'X.mat'),'X');

    end
end
