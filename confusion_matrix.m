function [precision, recall, AA, OA, APR, OPR, confus_m] = confusion_matrix(gt, estim_map)
% Classification evaluation
% Inputs
%   gt - ground truth
%   estim_map - classification result
% Outputs
%   precision - single class precision
%   recall - single class accuracy
%   AA - average accuracy
%   OA - overall accuracy
%   APR - average precision
%   OPR - overall precision
%   confus_m - confusion matrix

   [num_row, num_col] = size(gt);
   N = num_row*num_col;
   gt = reshape(gt,N,1);
   estim_map = reshape(estim_map,N,1);
   
   no_class = max(gt(:)) + 1;
   gt(gt == 0) = no_class;
   
   % Create confusion matrix
   confus_m = zeros(no_class);      
    for i = 1:N
        estim_pos = unique(estim_map(i,:));
        if((length(estim_pos)~=1)&&(estim_pos(1)==0))
            estim_pos(1) = [];
        end
        if((length(estim_pos)==1)&&(estim_pos(1)==0))
            estim_pos(1) = no_class;
        end
        confus_m(gt(i),estim_pos) = confus_m(gt(i),estim_pos)+1;
    end
    
    % one class precision 
    precision = diag(confus_m)./sum(confus_m,1)'; 
    precision(isnan(precision)) = 0;
    precision(no_class) = [];

    % one class accuracy 
    recall = diag(confus_m)./sum(confus_m,2);
    recall(isnan(recall)) = 0;
    recall(no_class) = [];

    % average accuracy
    AA = sum(recall)/(no_class-1);
    
    % overall accuracy
    confus_m_oa = confus_m(1:no_class-1,1:no_class-1);
    OA = trace(confus_m_oa)/sum(sum(confus_m(1:no_class-1,:))); 
    
    % average precision 
    APR = sum(precision)/(no_class-1);
   
    % overall precision 
    confus_pr = confus_m(:,1:no_class-1);
    OPR =  trace(confus_m_oa)/sum(sum(confus_pr(:)));
    
end