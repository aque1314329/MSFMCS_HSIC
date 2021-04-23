% This demo implements the MSFMCS using SVM as initial classifier for 
% hyperspectral image classification [1]
%
% More details in:
% [1] X. Shang, M. Song, and C. Chang, Multi-Spatial Filtering Module
% Cascaded System for Hyperspectral Image Classification.
% IEEE Transactions on Geoscience and Remote Sensing, 2021. 
%
% contact: shangxd329@dlmu.edu.cn (Xiaodi Shang)

clear all;  clc; 
close all;

%%%% load hyeprspectral image
path='.\Dataset\';
inputs = 'IP';
location = [path,inputs];
load (location);
no_classes = max(gt(:));
GroundT=GroundT';
[no_lines,no_rows,no_bands] = size(img);  

%%%% select training samples for SVM classification in kth SFM
ts_rate = 0.05; % training sample rate
no_train = round(length(GroundT)*ts_rate);
indexes = train_test_random_new(GroundT(2,:),fix(no_train/no_classes),no_train);

%%%% set paramaters
flag_SelectTs = 1; % 1. fixed training sampling 2. random training sampling
reimg_EPF = ToVector(img); % reference image for EPF
iter = 1;  
SROA = []; % initial stopping rule 

%%%% Initial module - SC 
SVMmaps  = func_SVM( img, GroundT, indexes);
[precision, recall, AA, OA, APR, OPR, confus_m] = confusion_matrix(gt,SVMmaps);
SROA = [SROA OA];

%%%% Spatial filtering modules
tic   % document the running time
while(iter)
    
%%% spatial filter - edge preserving filter
[clasMap, EPFmap] = EPF(reimg_EPF,SVMmaps);
img = EPFmap;

%%% SVM classification after SF in kth spatial filtering modules
SVMmaps = func_SVM( img, GroundT, indexes );
[precision, recall, AA, OA, APR, OPR, confus_m] = confusion_matrix(gt,SVMmaps);
SROA = [SROA OA];

%%% stopping rule
if SROA(iter+1) <= SROA(iter)
    break;
end

%%% version - random training sampling
if flag_SelectTs == 2
    indexes = train_test_random_new(GroundT(2,:),fix(no_train/no_classes),no_train);
end

iter = iter+1;

end

running_time = toc;






