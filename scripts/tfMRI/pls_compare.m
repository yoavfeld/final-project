
clear
data_path = '/Users/yoav.feldman/fmri/final-project/scripts/tfMRI/';
fc_data_path = strcat(data_path,'fc_data/fc_7T_movie2/');
isfc_data_path = strcat(data_path,'isfc_data/isfc_7T_movie2/');

movie_number = 2;
nets = 13;
parts = 4;
components = 10;

net_names = {'Primary Visual', 'Secondary Visual', 'Somatomotor', 'Cingulo-Opercular', 'Dorsal-attention', 'Language', 'Frontoparietal', 'Auditory', 'Default', 'Posterior Multimodal', 'Ventral Multimodal', 'Orbito-Affective', 'All Brain'};
rng(0);
for net=1:nets
    fc_plot_corr = [];
    isfc_plot_corr = [];
    for p=1:parts
        
        % Do pls on fc
        fc_part_path = strcat(fc_data_path, 'net_', string(net), '/part_' , string(p));
        X_path = strcat(fc_part_path, '/X.mat');
        load(X_path, 'X');
        y_path = strcat(fc_part_path, '/Y_lin.mat');
        load(y_path, 'Y_lin');
        y = Y_lin';
        [cor, ~,~] = pls(X,y,components);
        fc_plot_corr = [fc_plot_corr, cor];
        
        % Do pls on isfc
        isfc_train_path = strcat(isfc_data_path, 'train/net_', string(net), '/part_' , string(p));
        load(strcat(isfc_train_path, '/X.mat'), 'X');
        X_train = X;
        load(strcat(isfc_train_path, '/Y_lin.mat'), 'Y_lin');
        y_train = Y_lin';
       
        isfc_test_path = strcat(isfc_data_path, 'test/net_', string(net), '/part_' , string(p));
        load(strcat(isfc_test_path, '/X.mat'), 'X');
        X_test = X;
        load(strcat(isfc_test_path, '/Y_lin.mat'), 'Y_lin');
        y_test = Y_lin';
      
        [cor, ~,yFit] = pls(X_train,y_train,X_test, y_test,components);
        isfc_plot_corr = [isfc_plot_corr, cor];
        
%         if net == 9 && p == 2
%             figure;
%             scatter(y_test, yFit, '*');
%             title('ISFC-DMN-PLS-5-components');
%             xlabel('observed');
%             ylabel('predicted');
%             lsline
%         end
    end
    
    b = subplot(4,4,net);
    bar([fc_plot_corr;isfc_plot_corr]');
    titl = strcat(net_names{net});
    title(titl);
    
    labels = {'part1','part2','part3','part4'};
    set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels));
    xtickangle(45);
end
subplot(4,4,16);
plot(0,0,  0,0,  0,0,  0,0);
axis off
legend('FC','ISFC', 'Location','southeast');
super_title = strcat('Movie-', string(movie_number),'-PLS-',string(components),'-components-FC-vs-ISFC');
[~,h] = suplabel(char(super_title), 't');
set(h,'FontSize',15);
saveas(b,strcat("plots/", super_title,".fig"));