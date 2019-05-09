

%labels =  %readtable('labels.csv');
load('labels.mat');
load('7_sub.mat');
out = [];

for i=1:size(labels(:,1))
    row = labels1(i,:);
    if max(ismember(seven_t, row(1))) == 1
        out = [out; row];
    end
end

save('7t_labels.mat', 'out');

