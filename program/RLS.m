function [Average_Precision,Civerage,RankingLoss] = RLS(Y,lambda,K1) {
%tju cs for bioinformatics

%Y  N*M  N numbers of samples M numbers of labels
%K1 N*N*S  S numbers of kernels
%lambda Parameter, adjustable 
index_y = 1:1:size(Y,1);
index_y = index_y';
nfolds = 5; nruns=1;
MU = 0.005;GAMMA=0.002;
predict_scores=[];
true_y=[];
for run=1:nruns
    % split folds
    crossval_idx = crossvalind('Kfold',index_y(:),nfolds);
    for fold=1:nfolds
        train_idx = find(crossval_idx~=fold);
        test_idx  = find(crossval_idx==fold);
        y_train = Y;
        y_train(test_idx,:) = 0;
        kernel_weights = [1/6;1/6;1/6;1/6;1/6;1/6];
        K_com = combine_kernels(kernel_weights, K1);
        predict_y=predict_kernel(y_train,K_com,lambda);
        %% evaluate predictions
        yy=Y;
        test_label = yy(test_idx,:);
        predict_com = predict_y(test_idx,:);
        predict_scores=[predict_scores;predict_com];fold
        true_y=[true_y;test_label];
    end
    %[X_c,Y_c,tpr,aupr_A_com] = perfcurve(true_y(:),predict_scores(:),1, 'xCrit', 'reca', 'yCrit', 'prec');
    Average_Precision=Average_precision(predict_scores',true_y')
    Coverage=coverage(predict_scores',true_y')
    RankingLoss=Ranking_loss(predict_scores',true_y')
end
}
