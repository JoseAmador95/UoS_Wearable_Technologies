%% dtcWrapperFS
% Performs an exhaustive wrapper feature selection using Matlab's built-in 
% classifiers. The function was modified to print once every 5000
% iteartions.
%
% Input:
%   data_train:     nsxnf matrix of ns samples (lines) with nf features
%                   (columns)
%   label_train:    nsx1 column vector with the numeric class label
%   data_test:      nsxnf matrix of ns samples (lines) with nf features
%                   (columns)
%   label_test:     nsx1 column vector with the numeric class label
%   fitfcn:         Pointer to one of the Matlab built-in classifier
%                   training function (e.g. fitcnb, fitcknn, etc).
%   
%
% Output:   
%   acc:            2^nf-1x1 column vector containing the accuracy for
%               	every feature combination. 
%                   Features are selected by a bitmask. 
%                   Each line corresponds to a different bitmask, with the
%                   line number representing the binary bitmask.
%                   Line 1 corresponds to features [0 0 0 .... 0 0 1]
%                   Line 2 corresponds to features [0 0 0 .... 0 1 0]
%   bestacc:        Best accuracy reached
%   bestfeatures:   Bitmap with best features
% 
% 
function [acc,bestacc,bestfeatures]=dtcWrapperFS(data_train,label_train,data_test,label_test,fitfcn)

% Number of features
nf = size(data_train,2);
% Resulting performance
acc=zeros(2^nf-1,1);
bestfsel=false(1,nf);
bestacc=0;

total =  2^nf-1;
for f=1:total
    % fsel: bitmap containing which features are selected
    fsel=logical(de2bi(f,nf,'right-msb'));
    
    classifier = feval(fitfcn,data_train(:,fsel),label_train);
    
    label_pred = predict(classifier,data_test(:,fsel));
    acc(f)=sum(label_pred==label_test)/length(label_test);
    
    if(acc(f)>bestacc)
        bestacc=acc(f);
        bestfeatures=fsel;
    end
    if mod(f,5000) == 0 || f == total || f == 1
        fprintf(1,'%d/%d. Current: %f, Best: %f, Feature Map: %s\n',f, total, acc(f),bestacc,num2str(find(bestfeatures)));
    end
end




