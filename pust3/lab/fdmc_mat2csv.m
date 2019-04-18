load('dmc_lab_rozmyty_I.mat')

stpt_ts = [linspace(1,1000,1000)' stpt'];
dlmwrite(strcat('../data/lab/zad5/proba1_stpt.csv'), stpt_ts, '\t');

output_ts = [linspace(1,1000,1000)' output];
dlmwrite(strcat('../data/lab/zad5/proba1_output.csv'), output_ts, '\t');

input_ts = [linspace(1,1000,1000)' input];
dlmwrite(strcat('../data/lab/zad5/proba1_input.csv'), input_ts, '\t');


load('dmc_lab_rozmyty_II.mat')

stpt_ts = [linspace(1,1000,1000)' stpt'];
dlmwrite(strcat('../data/lab/zad5/proba2_stpt.csv'), stpt_ts, '\t');

output_ts = [linspace(1,1000,1000)' output];
dlmwrite(strcat('../data/lab/zad5/proba2_output.csv'), output_ts, '\t');

input_ts = [linspace(1,1000,1000)' input];
dlmwrite(strcat('../data/lab/zad5/proba2_input.csv'), input_ts, '\t');


load('dmc_lab_rozmyty_III.mat')

stpt_ts = [linspace(1,1000,1000)' stpt'];
dlmwrite(strcat('../data/lab/zad5/proba3_stpt.csv'), stpt_ts, '\t');

output_ts = [linspace(1,1000,1000)' output];
dlmwrite(strcat('../data/lab/zad5/proba3_output.csv'), output_ts, '\t');

input_ts = [linspace(1,1000,1000)' input];
dlmwrite(strcat('../data/lab/zad5/proba3_input.csv'), input_ts, '\t');