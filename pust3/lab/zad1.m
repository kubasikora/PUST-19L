clear all
load('lab1.mat');

inputs = 1:length(y);
pp_ts = [inputs' y'];
dlmwrite(strcat('../data/lab/zad1/punkt_pracy.csv'), pp_ts, '\t');

plot(y);