%% note: remove rng from pls.m
clear
data_path = pwd;
fc_data_path = strcat(data_path,'/fc_data/fc_7T_movie2/');
isfc_data_path = strcat(data_path,'/isfc_data/isfc_7T_movie2/');

movie_number = 2;
net = 9;
parts = 4;
components = 5;
permutations = 200;

net_names = {'Primary Visual', 'Secondary Visual', 'Somatomotor', 'Cingulo-Opercular', 'Dorsal-attention', 'Language', 'Frontoparietal', 'Auditory', 'Default', 'Posterior Multimodal', 'Ventral Multimodal', 'Orbito-Affective', 'All Brain'};
rng(0);
fc_plot_corr = [];
isfc_plot_corr = [];

for part=1:parts
    
    %fc X
    fc_part_path = strcat(fc_data_path, 'net_', string(net), '/part_' , string(part));
    X_path = strcat(fc_part_path, '/X.mat');
    load(X_path, 'X');
    X_fc = X;
    
    % loading y
    y_path = strcat(fc_part_path, '/Y_lin.mat');
    load(y_path, 'Y_lin');
    y = Y_lin';
    
    %isfc X
    isfc_train_path = strcat(isfc_data_path, 'train/net_', string(net), '/part_' , string(part));
    load(strcat(isfc_train_path, '/X.mat'), 'X');
    X_train = X;
    isfc_test_path = strcat(isfc_data_path, 'test/net_', string(net), '/part_' , string(part));
    load(strcat(isfc_test_path, '/X.mat'), 'X');
    X_test = X;
    
    fc_corr_hist = [];
    isfc_corr_hist = [];
    cor_sum_isfc = 0;
    cor_sum_fc = 0;
    for p=1:permutations
        y_rand = y(randperm(length(y)));
        
        [cor, ~,~] = pls(X_fc,y_rand,components);
        cor_sum_fc = cor_sum_fc + cor;
        fc_corr_hist = [fc_corr_hist, cor];
        
        y_train = y_rand(1:130);
        y_test = y_rand(131:end);
        [cor, ~,~] = pls(X_train,y_train,X_test, y_test,components);
        cor_sum_isfc = cor_sum_isfc + cor;
        isfc_corr_hist = [isfc_corr_hist, cor];
    end
    fc_plot_corr = [fc_plot_corr, cor_sum_fc/permutations];
    isfc_plot_corr = [isfc_plot_corr, cor_sum_isfc/permutations];
    
    %figure;
    b = subplot(4,2,(part-1)*2 + 1);
    hist(fc_corr_hist);
    title(strcat('fc-part-', string(part)));
    %figure;
    sp = subplot(4,2,(part-1)*2 + 2);
    hist(isfc_corr_hist);
    title(strcat('isfc-part-', string(part)));
    
    
end
super_title = strcat('PLS-',string(permutations),'-shuffle-correlations-histograms-', net_names{net});
[~,h] = suplabel(char(super_title), 't');
set(h,'FontSize',15);
saveas(sp,strcat("plots/", super_title,".fig"));

figure
b=bar([fc_plot_corr;isfc_plot_corr]');
titl = strcat('PLS-',string(permutations),'-shuffle-labels-movie-',string(movie_number),'-', net_names{net});
title(titl);
labels = {'part1','part2','part3','part4'};
set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels));
xtickangle(45);
legend('FC','ISFC', 'Location','southeast');
saveas(b,strcat("plots/", titl,".fig"));
%saveas(b,strcat("plots/", titl,".jpg"));
        