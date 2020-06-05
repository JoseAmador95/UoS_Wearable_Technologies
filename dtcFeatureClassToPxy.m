%% dtcFeatureClassToPxy
%
%   f:              nsx1 column vector of 1D feature; each line corresponds to a sample.
%   l:              nsx1 column vector of labels; each line corresponds to
%                   a sample. The labels must be from 1 to C.

function pxy = dtcFeatureClassToPxy(f,l)


[n,edge,bin]=histcounts(f, 'BinMethod', 'sturges');
%figure;
%histogram(f(:,feat), 'BinMethod', 'sturges');
%[n,edge,bin]=histcounts(f(:,feat), 'BinMethod', 'sqrt');
% Compute the joint pdf x by looking up each data point and adding it to
% pxy at the line given by the class and column given by the bin
pxy=zeros(length(unique(l)),length(n));
for i=1:size(f,1)
    pxy(l(i),bin(i))=pxy(l(i),bin(i))+1;
end
pxy=pxy./sum(sum(pxy));