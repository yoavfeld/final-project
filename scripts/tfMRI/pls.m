function [corr, y_test, yfitval] = pls(varargin) %(X, y, comp)

    if length(varargin) == 3
        X = varargin{1};
        y = varargin{2};
        comp = varargin{3};
        X_train = X(1:150,:);
        y_train = y(1:150);
        X_test = X(151:end,:);
        y_test = y(151:end);
    elseif length(varargin) == 5
        X_train = varargin{1};
        y_train = varargin{2};
        X_test = varargin{3};
        y_test = varargin{4};
        comp = varargin{5};
    else
        % init param when script is run without input params.
        load('net_13_part_2_X.mat', 'X');
        load('Y_lin.mat');
        y = Y_lin';
        comp = 4;
        
        X_train = X(1:150,:);
        y_train = y(1:150);
        X_test = X(151:end,:);
        y_test = y(151:end);
    end

    %rng(1);
    [XL,yl,XS,YS,beta,PCTVAR,MSE,stats] = plsregress(X_train,y_train,comp, 'CV', 10);
    
    yfitval = [ones(size(X_test,1),1) X_test]*beta;
    corr_mat = corrcoef(y_test,yfitval);
    corr = corr_mat(1,2);
    %result: 0.3455
    %plot(y_test,yfitval,'o')

    TSSVal = sum((y_test-mean(y_test)).^2);
    RSSVal = sum((y_test-yfitval).^2);
    RsquaredVal = 1 - RSSVal/TSSVal;

end


