
clear
data_path = pwd;
fc_data_path = strcat(data_path,'/fc_data/');
isfc_data_path = strcat(data_path,'/isfc_data/');

net = 13;
components = 5;

movies_parts = [4,3,4,4];
parts_names = {'Twomen','Bridgev','Pockets','HumanBody','Inception','SocialNet','Oceans','Flower','Overcome','Garden','Hotel','Homealone','Brockovich','Starwars','Dreary'};
net_names = {'Primary Visual', 'Secondary Visual', 'Somatomotor', 'Cingulo-Opercular', 'Dorsal-attention', 'Language', 'Frontoparietal', 'Auditory', 'Default', 'Posterior Multimodal', 'Ventral Multimodal', 'Orbito-Affective', 'All Brain'};
rng(0);

fc_plot_corr = [];
isfc_plot_corr = [];
for movie=1:length(movies_parts)
    movie_fc_data_path = strcat(fc_data_path,'fc_7T_movie', string(movie), '/');
    movie_isfc_data_path = strcat(isfc_data_path,'isfc_7T_movie', string(movie), '/');
    parts = movies_parts(movie);
    for p=1:parts
        
        % Do pls on fc
        fc_part_path = strcat(movie_fc_data_path, 'net_', string(net), '/part_' , string(p));
        X_path = strcat(fc_part_path, '/X.mat');
        load(X_path, 'X');
        y_path = strcat(fc_part_path, '/Y_lin.mat');
        load(y_path, 'Y_lin');
        y = Y_lin';
        [cor, ~,~] = pls(X,y,components);
        fc_plot_corr = [fc_plot_corr, cor];
        
        % Do pls on isfc
        isfc_train_path = strcat(movie_isfc_data_path, 'train/net_', string(net), '/part_' , string(p));
        load(strcat(isfc_train_path, '/X.mat'), 'X');
        X_train = X;
        load(strcat(isfc_train_path, '/Y_lin.mat'), 'Y_lin');
        y_train = Y_lin';
       
        isfc_test_path = strcat(movie_isfc_data_path, 'test/net_', string(net), '/part_' , string(p));
        load(strcat(isfc_test_path, '/X.mat'), 'X');
        X_test = X;
        load(strcat(isfc_test_path, '/Y_lin.mat'), 'Y_lin');
        y_test = Y_lin';
      
        [cor, ~,yFit] = pls(X_train,y_train,X_test, y_test,components);
        isfc_plot_corr = [isfc_plot_corr, cor];
    end
   
    
end

b = bar([fc_plot_corr;isfc_plot_corr]');
titl = strcat('PLS-',string(components),'-Components-Cross-Movies-FC-vs-ISFC-',net_names{net});
title(titl);
set(gca, 'XTickLabel',parts_names, 'XTick',1:numel(parts_names));
xtickangle(45);
legend('FC','ISFC', 'Location','southeast');
saveas(b,strcat("plots/cross/", titl,".fig"));