% 
% 
function l=nccpredict(nccmodel,f_test)

% number of classes are number of lines in nccmodel
nclass=size(nccmodel,1);

% number of samples are number of lines in f_test
nsample=size(f_test,1);

% Initialise the labels
l=zeros(nsample,1);

% Iterate all the labels
for i=1:nsample
    % Find shortest distance. 
    % We use some matlab matrix magic for this.
    % We first replicate the feature vector vertically for as many lines 
    % as there are classes
    t=repmat(f_test(i,:),nclass,1);
    % we compute the difference between class centers and feature vector
    d=nccmodel-t;
    % compute the euclidian distance
    d = sqrt(sum(d.*d,2));
    % the index of the smallest distance gives the label
    [m,idx]=min(d);
    l(i)=idx;
end

