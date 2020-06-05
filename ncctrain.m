%% NCC classifier
% Write code to train an NCC model.
% The NCC model consists of the class centers.
%
% f:    Ni x Nf feature matrix. The Ni lines correspond to Ni instances.
%       The Nf columns corresponds to Nf features.
% l:    Ni x 1 label vector. Each line contains the label of the corresponding feature vector in f.
%       The labels must have numeric values from 1, 2, ..., C, with C the number
%       of classes.
%
% Objective: modify the function below so that an NCC classifier is returned for the 
% training data f,l.
% The NCC model is very simple: it is the class center of each class!
% We wish to return a matrix of size C x Nf, with C the number of classes 
% and Nf the number of features. 
% Each line i must contain the center of class i.
%
function model=ncctrain(f,l)

% Get all the labels that exist; unique returns a sorted array with C
% elements if there are C unique values in l.
% (we need a transpose because the for loop below expects a row vector)
u=unique(l)';

% create the model as a matrix with number of lines equal to number of
% classes, and number of columns equal to number of features.
model = zeros(length(u),size(f,2));

% The model is currently "untrained". All the class centers are initialised
% to zero. You must now find the class centers by completing the program
% below.

% One approach consists in iterating all the classes
for class=u
    %--------------------------------------------------
    %--------------------------------------------------
    % CHANGE BELOW 
    % The following line says the center of class 'class' is a zero vetor of length number of features.
    % This must be replaced by the actual center of the samples
    % corresponding to 'class'.
    % 
    % Several approaches are possible. 
    % Naive approach: iterate through the array f and l, check if l is
    % equal to class; if yes add the feature vector to a 'sum' variable and
    % increment a counter by one. Once you've iterated, divide the sum
    % variable by the counter: this gives the mean feature vector for
    % 'class.
    %
    % Better approach: use the vector operations of Matlab. The expression
    % l==class returns a vector as long as l where each entry li of l is 
    % one l_i is equal to class, or zero if l_i is different than class.
    % The vector l==class can be used as an index to select all the lines
    % of f where l is equal to class: f(l==class,:)
    % This would allow to very easily compute the class mean.
    %
    
    % model(class,:) = zeros(1,size(f,2));
    model(class,:) = mean(f(l==class,:));


end


end