function [predict_y,Scores,kernel_weights] = mk_svm(train_x,feature_id,train_y,test_x,test_y,c,gamma_list)
%tju cs for bioinformatics 

%train_x, N*D N:numbers of train samples, D: Feature dimensions. Including m kinds of features
%feature_id, m*2 m:  kinds of features, 2: 2 cols, star id of feature in train_x(or test_x), and end id of feature in train_x(or test_x)
%train_y, N*1 N:numbers of train samples, train labels
%test_x, Te_N*D Te_N:numbers of test samples
%test_y, Te_N*1 
%c, the parameter of LIBSVM
%gamma_list, m*1 m:  kinds of features, different feature has different gamma (the RBF parameter of LIBSVM)
%r_lamda, Regularized item of multiple kernel learning(20000)
predict_y=[];
Scores=[];
kernel_weights=[];
m = size(feature_id,1);
num_train_samples = size(train_x,1);
num_test_samples = size(test_x,1);

%1.computer training and test kernels (with RBF)
K_train=[];
K_test=[];
for i=1:m

	kk_train = kernel_RBF(train_x(:,feature_id(i,1):feature_id(i,2)),train_x(:,feature_id(i,1):feature_id(i,2)),gamma_list(i));
	K_train(:,:,i)=kk_train;
	
	kk_test = kernel_RBF(test_x(:,feature_id(i,1):feature_id(i,2)),train_x(:,feature_id(i,1):feature_id(i,2)),gamma_list(i));
	K_test(:,:,i)=kk_test;
end


%2.multiple kernel learning
kernel_weights = [1/6;1/6;1/6;1/6;1/6;1/6];
K_train_com = combine_kernels(kernel_weights, K_train);
K_test_com = combine_kernels(kernel_weights, K_test);

%3.train and test model
K_train_com = [(1:num_train_samples)',K_train_com];
cg_str=['-t 4 -c ' num2str(c) ' -b 1'];
model = svmtrain(train_y, K_train_com, cg_str);
K_test_com = [(1:num_test_samples)',K_test_com];
[predict_y, accuracy1, Scores] = svmpredict(test_y,K_test_com,model,'-b 1');

end

%RBF kernel function
function k = kernel_RBF(X,Y,gamma)
	r2 = repmat( sum(X.^2,2), 1, size(Y,1) ) ...
	+ repmat( sum(Y.^2,2), 1, size(X,1) )' ...
	- 2*X*Y' ;
	k = exp(-r2*gamma); % 
end