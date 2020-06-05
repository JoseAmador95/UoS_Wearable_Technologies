function i=mi(pxy)

px=sum(pxy,1);
py=sum(pxy,2);
pxpy=py*px;

% If a probability pxy is zero, the log will be -inf.
% However lim x->0 of x*log(x) is zero. 
% Thereforewe patch l2 to have zeros in the right place
l2 = log2(pxy./pxpy);
l2(pxy==0)=0;

% Original formulation:
% i=sum(sum(pxy.*log2(pxy./pxpy)));
% With handling of zero probabilities
plp = pxy.*l2;
i=sum(sum(plp));
