function [result ] = func_SVM( img, GroundT, indexes)
% Support vector machine
% Inputs
%     img - 3D data matrix (num_row, num_col, num_dim)
%     GroundT - ground truth
%     indexes - index of training samples to be selected
% Outputs
%     result - classification result 

[num_row,num_col,num_dim]  = size(img);
img = ToVector(img)';

%%% get the training-test indexes
train_SL = GroundT(:,indexes);
test_SL = GroundT;
test_SL(:,indexes) = [];

%%% get the training-test samples and labels
train_samples = img(:,train_SL(1,:))';
train_labels = train_SL(2,:)';
test_samples = img(:,test_SL(1,:))';
test_labels = test_SL(2,:)';

%%%% Normalize the training set and original image
[train_samples,M,m] = scale_func(train_samples);
[img ] = scale_func(img',M,m);

%%%% Select the paramter for SVM with five-fold cross validation
[Ccv Gcv cv cv_t] = cross_validation_svm(train_labels,train_samples);

%%%% Training using a Gaussian RBF kernel
%%% give the parameters of the SVM (Thanks Pedram for providing the
%%% parameters of the SVM)
parameter = sprintf('-c %f -g %f -m 500 -t 2 -q',Ccv,Gcv); 

%%% Train the SVM
model = svmtrain(train_labels,train_samples,parameter);

%%%% SVM Classification
result = svmpredict(ones(num_row*num_col,1),img,model); 
result = reshape(result,num_row,num_col);

end

