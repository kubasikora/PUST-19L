nr_proby = 'PID_FINAL';

load(strcat(nr_proby, '.mat'));
output_ts_x = [(1:length(Y_x))' Y_x];
output_ts_y = [(1:length(Y_y))' Y_y];

input_ts_x = [(1:length(U_x))' U_x];
input_ts_y = [(1:length(U_y))' U_y];

stpt_ts_x = [(1:length(stpt1))' stpt1];
stpt_ts_y = [(1:length(stpt2))' stpt2];


dlmwrite(strcat('./zad10/', nr_proby, '_output_x.csv'), output_ts_x, '\t');
dlmwrite(strcat('./zad10/', nr_proby, '_output_y.csv'), output_ts_y, '\t');

dlmwrite(strcat('./zad10/', nr_proby, '_input_x.csv'), input_ts_x, '\t');
dlmwrite(strcat('./zad10/', nr_proby, '_input_y.csv'), input_ts_y, '\t');

dlmwrite(strcat('./zad10/', nr_proby, '_stpt_x.csv'), stpt_ts_x, '\t');
dlmwrite(strcat('./zad10/', nr_proby, '_stpt_y.csv'), stpt_ts_y, '\t');