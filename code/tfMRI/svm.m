rng(1);
load('X.mat', 'X');
load('Y_9_classes.mat');
%load('Y_lin.mat');
y = Y_9_classes; % Y_lin

Mdl = fitcecoc(X,y);
k=8
c = crossval(Mdl, 'kfold', k)
loss = kfoldLoss(c)
%result: 0.8




