function [Average_Precision,Coverage,RankingLoss] = all_SVM(human_s,feature_id,Y,c,gamma_list) {
nfolds = 5;
%tju cs for bioinformatics 
%human_s, N*D N:numbers of train samples, D: Feature dimensions. Including m kinds of features
%feature_id, m*2 m:  kinds of features, 2: 2 cols, star id of feature in train_x(or test_x), and end id of feature in train_x(or test_x)
%Y, N*M N:numbers of train samples, M: numbers of labels.
%c, the parameter of LIBSVM
%gamma_list, m*1 m:  kinds of features, different feature has different gamma (the RBF parameter of LIBSVM)
all_y_labels = [];
predict_result = [];
predicted_result_Scores = [];
index_y = 1:1:N;
index_y = index_y';
crossval_idx = crossvalind('Kfold',index_y(:),nfolds);
for fold=1:nfolds
    train_idx = find(crossval_idx~=fold);
    test_idx  = find(crossval_idx==fold);
    predict = [];
    predict_Scores = [];
    y_label = [];
    for  i = 1:M
        test = [];
        y = Y(:,i);
        train_x = human_s(train_idx,:);
        train_y = y(train_idx,:);
        test_x = human_s(test_idx,:);
        test_y = y(test_idx,:);
        [predict_y,Scores,kernel_weights] = mk_svm(train_x,feature_id,train_y,test_x,test_y,c,gamma_list);i
        predict = [predict,predict_y];
        y_label = [y_label,test_y];
        predict_Scores = [predict_Scores,Scores];
    end
    predict_result = [predict_result;predict];
    all_y_labels = [all_y_labels;y_label];
    predicted_result_Scores = [predicted_result_Scores;predict_Scores];
end
ss = predicted_result_Scores(:,1:2:M*2);
Average_Precision=Average_precision(ss',all_y_labels')
Coverage=coverage(ss',all_y_labels')
RankingLoss=Ranking_loss(ss',all_y_labels')
}