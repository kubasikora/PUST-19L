load('skok_o_-10.mat')
output_ts = [(1:length(y))' y'];
dlmwrite(strcat('../data/lab/zad2_skok_o_-10.csv'), output_ts, '\t');

load('skok_o_-5.mat')
output_ts = [(1:length(y))' y'];
dlmwrite(strcat('../data/lab/zad2_skok_o_-5.csv'), output_ts, '\t');

load('skok_o_4.mat')
output_ts = [(1:length(y))' y'];
dlmwrite(strcat('../data/lab/zad2_skok_o_4.csv'), output_ts, '\t');

load('skok_o_10.mat')
output_ts = [(1:length(y))' y'];
dlmwrite(strcat('../data/lab/zad2_skok_o_10.csv'), output_ts, '\t');

load('pidK=1.mat')
input_ts = [(1:length(input))' input];
ouptut_ts = [(1:length(y))' y'];
stpt_ts = [(1:length(setpoint))' setpoint'];
dlmwrite(strcat('../data/lab/pid/input_k=1.csv'), input_ts, '\t');
dlmwrite(strcat('../data/lab/pid/output_k=1.csv'), output_ts, '\t');
dlmwrite(strcat('../data/lab/pid/stpt_k=1.csv'), stpt_ts, '\t');