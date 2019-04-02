load('zad5_DMC_Dz_200.mat')
output_ts = [(1:length(y))' y'];
input_ts = [(1:length(rescaled_input))' rescaled_input];
disturb_ts = [(1:length(disturbance))' disturbance'];
stpt_ts = [(1:length(setpoint))' setpoint'];
dlmwrite(strcat('../data/lab/zad5/output_Dz_200.csv'), output_ts, '\t');
dlmwrite(strcat('../data/lab/zad5/input_Dz_200.csv'), input_ts, '\t');
dlmwrite(strcat('../data/lab/zad5/disturb_Dz_200.csv'), disturb_ts, '\t');
dlmwrite(strcat('../data/lab/zad5/stpt_Dz_200.csv'), stpt_ts, '\t');

load('zad5_DMC_Dz_250.mat')
output_ts = [(1:length(y))' y'];
input_ts = [(1:length(rescaled_input))' rescaled_input];
disturb_ts = [(1:length(disturbance))' disturbance'];
stpt_ts = [(1:length(setpoint))' setpoint'];
dlmwrite(strcat('../data/lab/zad5/output_Dz_250.csv'), output_ts, '\t');
dlmwrite(strcat('../data/lab/zad5/input_Dz_250.csv'), input_ts, '\t');
dlmwrite(strcat('../data/lab/zad5/disturb_Dz_250.csv'), disturb_ts, '\t');
dlmwrite(strcat('../data/lab/zad5/stpt_Dz_250.csv'), stpt_ts, '\t');

load('zad5_DMC_Dz_300.mat')
output_ts = [(1:length(y))' y'];
input_ts = [(1:length(rescaled_input))' rescaled_input];
disturb_ts = [(1:length(disturbance))' disturbance'];
stpt_ts = [(1:length(setpoint))' setpoint'];
dlmwrite(strcat('../data/lab/zad5/output_Dz_300.csv'), output_ts, '\t');
dlmwrite(strcat('../data/lab/zad5/input_Dz_300.csv'), input_ts, '\t');
dlmwrite(strcat('../data/lab/zad5/disturb_Dz_300.csv'), disturb_ts, '\t');
dlmwrite(strcat('../data/lab/zad5/stpt_Dz_300.csv'), stpt_ts, '\t');

load('zad5_DMC_Dz_350.mat')
output_ts = [(1:length(y))' y'];
input_ts = [(1:length(rescaled_input))' rescaled_input];
disturb_ts = [(1:length(disturbance))' disturbance'];
stpt_ts = [(1:length(setpoint))' setpoint'];
dlmwrite(strcat('../data/lab/zad5/output_Dz_350.csv'), output_ts, '\t');
dlmwrite(strcat('../data/lab/zad5/input_Dz_350.csv'), input_ts, '\t');
dlmwrite(strcat('../data/lab/zad5/disturb_Dz_350.csv'), disturb_ts, '\t');
dlmwrite(strcat('../data/lab/zad5/stpt_Dz_350.csv'), stpt_ts, '\t');

load('zad5_DMC_Dz_400.mat')
output_ts = [(1:length(y))' y'];
input_ts = [(1:length(rescaled_input))' rescaled_input];
disturb_ts = [(1:length(disturbance))' disturbance'];
dlmwrite(strcat('../data/lab/zad5/output_Dz_400.csv'), output_ts, '\t');
dlmwrite(strcat('../data/lab/zad5/input_Dz_400.csv'), input_ts, '\t');
dlmwrite(strcat('../data/lab/zad5/disturb_Dz_400.csv'), disturb_ts, '\t');
dlmwrite(strcat('../data/lab/zad5/stpt_Dz_400.csv'), stpt_ts, '\t');