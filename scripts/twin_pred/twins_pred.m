
%corr_file = 'fc_rest_dmn_cov.mat';
%corr_file = 'fc_rest_all_brain_cov.mat';
%corr_file = 'isfc_movie1_cov.mat';
%corr_file = 'fc_movie_all_brain_cov.mat';
%load(corr_file);
%load(labels_file);

corr_mtx_path = [pwd, '/isfc_rest_cov/'];
labels_file = '7t_labels.mat'; 
th = 0; % threshold of corr values
count = 1; % how many highest correlations to take from each subject
from = 1; % from which highest correlation to start

twins_indexes_pred = get_twins_indexes(corr_mtx_path, 182, th, count, from);
n = size(twins_indexes_pred,1);

trues = 0;
falses = 0;

for t=1:n
    twins_p = twins_indexes_pred(t, :);
    bro1_p = twins_p(1);
    bro2_p = twins_p(2);
    
    % check if one of them is not twin
    if labels(bro1_p, 2) == 0 || labels(bro2_p, 2) == 0
        falses = falses+1;
        continue
    end
    
    %check if same family
    if labels(bro1_p, 3) == labels(bro2_p, 3)
        trues = trues + 1;
        continue
    end
    falses = falses+1;
end

falses
trues
err_rate = falses/(trues+falses)

