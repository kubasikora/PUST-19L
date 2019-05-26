nr_proby = 'PROBA1';

load(strcat(nr_proby, '.mat'));
output_ts_1 = [(1:length(y1))' y1'];
output_ts_2 = [(1:length(y2))' y2'];

input_ts_1 = [(1:length(u1))' u1];
input_ts_2 = [(1:length(u2))' u2];

stpt_ts_1 = [(1:length(stpt1))' stpt1'];
stpt_ts_2 = [(1:length(stpt2))' stpt2'];


dlmwrite(strcat('../data/lab/thermal_object/zad3/', nr_proby, 'output_1.csv'), output_ts_1, '\t');
dlmwrite(strcat('../data/lab/thermal_object/zad3/', nr_proby, 'output_2.csv'), output_ts_2, '\t');

dlmwrite(strcat('../data/lab/thermal_object/zad3/', nr_proby, 'input_1.csv'), input_ts_1, '\t');
dlmwrite(strcat('../data/lab/thermal_object/zad3/', nr_proby, 'input_2.csv'), input_ts_2, '\t');

dlmwrite(strcat('../data/lab/thermal_object/zad3/', nr_proby, 'stpt_1.csv'), stpt_ts_1, '\t');
dlmwrite(strcat('../data/lab/thermal_object/zad3/', nr_proby, 'stpt_2.csv'), stpt_ts_1, '\t');