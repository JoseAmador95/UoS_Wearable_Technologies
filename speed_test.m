%% Speed Test
% This script was used to measure the performance of the current
% classifier by running 1000 times the test data (as random data is not
% representative of a class) and measuring the elapsed time. This script
% requires to execute the main.m script.

set = repmat(test.features,1000,1);

tic % NCC
nccpredict(models.ncc,set);
t.ncc = toc/length(set);

tic % kNN
predict(models.knn,repmat(test.features,100,1));
t.knn = toc/length(set);

tic % DT
predict(models.dt,repmat(test.features,10,1));
t.dt = toc/length(set);

tic % NB
predict(models.nb,repmat(test.features,10,1));
t.nb = toc/length(set);

fprintf("NCC: %f us per prediction\n", t.ncc*1e6)
fprintf("kNN: %f us per prediction\n", t.knn*1e6)
fprintf("DT: %f us per prediction\n", t.dt*1e6)
fprintf("NB: %f us per prediction\n", t.nb*1e6)
