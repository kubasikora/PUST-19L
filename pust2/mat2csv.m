load('skok_zakl_o_-10.mat')
output_ts = [(1:length(y))' y'];
dlmwrite(strcat('../pust2/data/lab/zad2_skok_zakl_o_-10.csv'), output_ts, '\t');

load('skok_zakl_o_10.mat')
output_ts = [(1:length(y))' y'];
dlmwrite(strcat('../pust2/data/lab/zad2_skok_zakl_o_10.csv'), output_ts, '\t');

load('skok_zakl_o_20.mat')
output_ts = [(1:length(y))' y'];
dlmwrite(strcat('../pust2/data/lab/zad2_skok_zakl_o_20.csv'), output_ts, '\t');

load('skok_zakl_o_-20.mat')
output_ts = [(1:length(y))' y'];
dlmwrite(strcat('../pust2/data/lab/zad2_skok_zakl_o_-20.csv'), output_ts, '\t');

% load('pidK=1.mat')
% input_ts = [(1:length(input))' input];
% ouptut_ts = [(1:length(y))' y'];
% stpt_ts = [(1:length(setpoint))' setpoint'];
% dlmwrite(strcat('../data/lab/zad2/input_k=1.csv'), input_ts, '\t');
% dlmwrite(strcat('../data/lab/zad2/output_k=1.csv'), output_ts, '\t');
% dlmwrite(strcat('../data/lab/zad2/stpt_k=1.csv'), stpt_ts, '\t');