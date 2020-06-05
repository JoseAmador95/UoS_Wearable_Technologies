%% Classifier Designer
% This script performs the actions required in the report for designing a
% Machine Learning classifier. Each section can be executed individually
% and process parameters may be available to modify by the user. Please
% read carefully each one of the headers to find out which are the tunning
% variables.
clear

%% Dataset
% The dataset used for this classification is the guided set, as it is
% easier to classify.
load('dataset_usb_hci_dtc.mat');
dataset = dataset_usb_hci_guided_dtc;

% Style-guide for gestures. This colours are used in every gesture related
% plot and in the report.
sty = {'#0072BD','#D95319','#EDB120','#7E2F8E','#77AC30'};

%% Data Selection
% The data selection stage section consist of two parameters, the sensor
% selection and candidate feature list. The sensor selection allows to
% combine axes from different sensors. The candidate features are meant to
% be coded in the feature_list.m function. 

sensors = [7 8 9]; % Correspoinding to Sensor 3
[~, feat_names] = feature_list(0); % Get the feature list from the function
N_feat = length(sensors) * length(feat_names);
for s = 1:length(sensors)
    j = 1;
    for class = 1:length(dataset{sensors(s)})
        for i = 1:length(dataset{sensors(s)}{class})
            data = dataset{sensors(s)}{class}{i};
            features(j,(s-1)*length(feat_names)+1:s*length(feat_names)) ...
                = feature_list(data);
            label(j,:) = class;
            j = j + 1;
        end
    end
end

%% Probability Density Function
% This section displays the PDF plot for every feature and sensor. A total
% of length(sensors) * length(feat_names) plots are displayed.
figure(1)
clf
for s = 0:(length(sensors)-1)
    for f = 1:length(feat_names)
        subplot(ceil(size(features,2)/5),5,f+s*length(feat_names));
        dtcPlotFeatureSpace1D(features(:,f+s*length(sensors))', label', sty);
        title(strcat("S", num2str(sensors(s+1)), ": ", feat_names(f)));
    end
end

%% Mutial Information
% The MI filter is used to rank the features using their individual
% contribution to the classification.

% Get the probability of each gesture in all features and use the MI to
% estimate the information gain.
frank=zeros(10,3);
for feat=1:size(features,2)
    frank(feat,1)=feat;
    pxy=dtcFeatureClassToPxy(features(:,feat),label); % Get Probability
    fr_mi=mi(pxy); % Get MI
    fprintf(1,'Feature %d: MI %f\n',feat,fr_mi);
    frank(feat,2)=fr_mi; % Store feature number and MI
end

% Sort the features by information gain.
[~,fi_mi]=sort(frank(:,2),1,'descend');
f_n = frank(fi_mi,1)';

disp('Features sorted by MI, best first:');disp(f_n);

%% Feature Extraction Wrapper
% The feature selection wrapper iterates through every feature combination
% to get the best of them all. Two wrappers are used, one for DT and the
% other for NB. The top 5 combinations are displayed for further analisys.

% Execute the wrappers
[accuracy_dt,bestacc_dt,bestfeatures_dt]=dtcWrapperFS(features(1:2:end,:),label(1:2:end),features(2:2:end,:),label(2:2:end),@fitctree);
[accuracy_nb,bestacc_nb,bestfeatures_nb]=dtcWrapperFS(features(1:2:end,:),label(1:2:end),features(2:2:end,:),label(2:2:end),@fitcnb);

% Sort the combinations by accuracy
[topacc_nb, topbcomb_nb] = sort(accuracy_nb, 'descend');
[topacc_dt, topbcomb_dt] = sort(accuracy_dt, 'descend');

% Display the top 5 combinations as a binary array
comb2feat.dt = @(x, n) dec2bin(topbcomb_dt(x),n);
comb2feat.nb = @(x, n) dec2bin(topbcomb_nb(x),n);

disp('Top feature combinations for DT (left-MSB)')
for i = 1:5
    fprintf("%d: %s, acc: %f\n", i, comb2feat.dt(i,N_feat), topacc_dt(i))
end

disp('Top feature combinations for NB (left-MSB)')
for i = 1:5
    fprintf("%d: %s, acc: %f\n", i, comb2feat.nb(i,N_feat), topacc_nb(i))
end

% Display the best combination for each wrapper specifying the sensor
% number and feature number.
j = 1;
for f = 1:length(bestfeatures_dt)
    if bestfeatures_dt(f) == 1
        best_dt(j) = strcat("S", num2str(sensors(ceil(f/length(feat_names)))), ":", num2str(mod(f-1,length(feat_names))+1));
        j = j + 1;
    end
end
j = 1;
for f = 1:length(bestfeatures_nb)
    if bestfeatures_nb(f) == 1
        best_nb(j) = strcat("S", num2str(sensors(ceil(f/length(feat_names)))), ":", num2str(mod(f-1,length(feat_names))+1));
        j = j + 1;
    end
end

fprintf('Wrapper FS, best DT accuracy: %f with features:\n',bestacc_dt);
disp(best_dt)
fprintf('Wrapper FS, best NB accuracy: %f with features:\n',bestacc_nb);
disp(best_nb)

%% Feature Set Selection
% This section allows to select the feature set used in the following
% sections.

%feat_sel = logical([0 0 0 0 0 0 0 0 0 0 0 0 0 0 1]); % Use arbitrary features
%feat_sel = logical(comb2feat.dt(2, N_feat)-'0'); % Use the second best combination for dt
feat_sel = logical(comb2feat.nb(1, N_feat)-'0'); % Use the best combination for nb
candidate_features = features;
assert(length(feat_sel) <= size(features, 2), 'Feature Set greater than the number of available features')
features = features(:, feat_sel);

%% Dimension Reduction
% Dimension reducion techniques are used to visualize the feature set in a
% 2D or 3D space. This must be set to 2D or 3D in order to see the
% decision boundaries. If the selected feature set is not greater than 3,
% then this step may be skipped.

Dim = 3; % Select resulting dimension (1, 2 or 3)
assert(Dim > 1, '1D reduction not supported')

[~,pca_comp,~,~,~]=pca(features, 'NumComponents',Dim);
figure(2); clf;
subplot(2,1,1)
for class = 1:5
    point = [pca_comp zeros(size(pca_comp,1),3-Dim)];
    scatter3(point(label == class,1), point(label == class,2), point(label == class,3), ...
        'MarkerFaceColor', sty{class}, 'MarkerEdgeColor', 'k')
    hold on
end
grid on
title 'PCA'

subplot(2,1,2)
[fda_comp, w] = FDA(features', label, Dim);
fda_comp = fda_comp';
for class = 1:5
    point = [fda_comp zeros(size(fda_comp,1), 3-Dim)];
    point = point(label == class,:);
    scatter3(point(:,1), point(:,2), point(:,3), ...
        'MarkerFaceColor', sty{class}, 'MarkerEdgeColor', 'k')
    hold on
    bound = boundary(point(:,1), point(:,2), point(:,3), 0);
    plot3(point(bound,1), point(bound,2), point(bound,3), 'color', sty{class})
end
grid on
title 'LDA'

%% Training & Testing Datasets
% This section selects the training dataset based on the number of features
% selected previously. The user may select to use or not the reduced
% feature set if the number of features is greater than 3 in order to see
% the decision boundaries. Doing this will affect the classifier's
% performance. 50% data is used for training.

use_reducted_set = true; % Use reduced feature set?
if size(features, 2) > 3 && use_reducted_set
    % Select the reduced set
    train.features = fda_comp(1:2:end,:);
    test.features = fda_comp(2:2:end,:);
    db_set = fda_comp;
else
    % Select the unprocesssed set
    train.features = features(1:2:end,:);
    test.features = features(2:2:end,:);
    db_set = features;
end

train.label = label(1:2:end);
test.label = label(2:2:end);

%% Training & Testing
% This section uses the previous parameters to train and display the
% resulting accuracy of the classifier.

models.ncc= zeros(length(unique(train.label)), size(train.features, 2));
for class = 1:length(unique(train.label))
    models.ncc(class,:) = mean(train.features(train.label == class,:));
end

predicted.ncc = nccpredict(models.ncc, train.features);
acc=sum(predicted.ncc==test.label)/length(test.label);
fprintf(1,'Accuracy NCC: %f\n',acc);
models.knn = fitcknn(train.features,train.label,'NumNeighbors',1);
predicted.knn = predict(models.knn,test.features);
acc=sum(predicted.knn==test.label)/length(test.label);
fprintf(1,'Accuracy kNN: %f\n',acc);
models.dt = fitctree(train.features,train.label);
predicted.dt = predict(models.dt,test.features);
acc=sum(predicted.dt==test.label)/length(test.label);
fprintf(1,'Accuracy  DT: %f\n',acc);
models.nb = fitcnb(train.features,train.label);
predicted.nb = predict(models.nb,test.features);
acc=sum(predicted.nb==test.label)/length(test.label);
fprintf(1,'Accuracy  NB: %f\n',acc);

%% Decision Boundaries
% The decision boundaries show the regions mapped to a combination of
% inputs. The inputs are assigned to be the reduced feature set as there is
% no way to plot something above 3D.

figure(3); clf;
subplot(2,2,1)
plotdb(db_set, sty, @nccpredict, models.ncc, 30)
title 'NCC'; grid on; xlabel 'LD1'; ylabel 'LD2'; zlabel 'LD3';
subplot(2,2,2)
plotdb(db_set, sty, @predict, models.knn, 30)
title 'KNN'; grid on; xlabel 'LD1'; ylabel 'LD2'; zlabel 'LD3';
subplot(2,2,3)
plotdb(db_set, sty, @predict, models.dt, 30)
title 'DT'; grid on; xlabel 'LD1'; ylabel 'LD2'; zlabel 'LD3';
subplot(2,2,4)
plotdb(db_set, sty, @predict, models.nb, 30)
title 'NB'; grid on; xlabel 'LD1'; ylabel 'LD2'; zlabel 'LD3';

%% Speed performance
% The following stage may be skipped, as can be run using the speed_test.m
% function by itself.

disp('Speed Test')
speed_test