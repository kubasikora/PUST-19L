load('pidK=1.mat')
input_ts = [(1:length(input))' input];
output_ts = [(1:length(y))' y'];
stpt_ts = [(1:length(setpoint))' setpoint'];
dlmwrite(strcat('../../data/lab/pid/input_k=1.csv'), input_ts, '\t');
dlmwrite(strcat('../../data/lab/pid/output_k=1.csv'), output_ts, '\t');
dlmwrite(strcat('../../data/lab/pid/stpt_k=1.csv'), stpt_ts, '\t');
disp([K Ti Td error_sum]);

load('pidK=20.mat')
input_ts = [(1:length(input))' input];
output_ts = [(1:length(y))' y'];
stpt_ts = [(1:length(setpoint))' setpoint'];
dlmwrite(strcat('../../data/lab/pid/input_k=20.csv'), input_ts, '\t');
dlmwrite(strcat('../../data/lab/pid/output_k=20.csv'), output_ts, '\t');
dlmwrite(strcat('../../data/lab/pid/stpt_k=20.csv'), stpt_ts, '\t');
disp([K Ti Td error_sum]);


load('pidK=40.mat')
input_ts = [(1:length(input))' input];
output_ts = [(1:length(y))' y'];
stpt_ts = [(1:length(setpoint))' setpoint'];
dlmwrite(strcat('../../data/lab/pid/input_k=40.csv'), input_ts, '\t');
dlmwrite(strcat('../../data/lab/pid/output_k=40.csv'), output_ts, '\t');
dlmwrite(strcat('../../data/lab/pid/stpt_k=40.csv'), stpt_ts, '\t');
disp([K Ti Td error_sum]);

load('pidK=20Ti=200.mat')
input_ts = [(1:length(input))' input];
output_ts = [(1:length(y))' y'];
stpt_ts = [(1:length(setpoint))' setpoint'];
dlmwrite(strcat('../../data/lab/pid/input_k=20_ti=200.csv'), input_ts, '\t');
dlmwrite(strcat('../../data/lab/pid/output_k=1_ti=200.csv'), output_ts, '\t');
dlmwrite(strcat('../../data/lab/pid/stpt_k=1_ti=200.csv'), stpt_ts, '\t');
disp([K Ti Td error_sum]);

load('pidK=20Ti=500.mat')
input_ts = [(1:length(input))' input];
output_ts = [(1:length(y))' y'];
stpt_ts = [(1:length(setpoint))' setpoint'];
dlmwrite(strcat('../../data/lab/pid/input_k=20_ti=500.csv'), input_ts, '\t');
dlmwrite(strcat('../../data/lab/pid/output_k=1_ti=500.csv'), output_ts, '\t');
dlmwrite(strcat('../../data/lab/pid/stpt_k=1_ti=500.csv'), stpt_ts, '\t');
disp([K Ti Td error_sum]);

load('pidK=20Ti=1000.mat')
input_ts = [(1:length(input))' input];
output_ts = [(1:length(y))' y'];
stpt_ts = [(1:length(setpoint))' setpoint'];
dlmwrite(strcat('../../data/lab/pid/input_k=20_ti=1000.csv'), input_ts, '\t');
dlmwrite(strcat('../../data/lab/pid/output_k=1_ti=1000.csv'), output_ts, '\t');
dlmwrite(strcat('../../data/lab/pid/stpt_k=1_ti=1000.csv'), stpt_ts, '\t');
disp([K Ti Td error_sum]);

load('pidK=20Ti=200Td=1.mat')
input_ts = [(1:length(input))' input];
output_ts = [(1:length(y))' y'];
stpt_ts = [(1:length(setpoint))' setpoint'];
dlmwrite(strcat('../../data/lab/pid/input_k=20_ti=200_td=1.csv'), input_ts, '\t');
dlmwrite(strcat('../../data/lab/pid/output_k=1_ti=200_td=1.csv'), output_ts, '\t');
dlmwrite(strcat('../../data/lab/pid/stpt_k=1_ti=200_td=1.csv'), stpt_ts, '\t');
disp([K Ti Td error_sum]);


load('pidK=20Ti=200Td=5.mat')
input_ts = [(1:length(input))' input];
output_ts = [(1:length(y))' y'];
stpt_ts = [(1:length(setpoint))' setpoint'];
dlmwrite(strcat('../../data/lab/pid/input_k=20_ti=200_td=5.csv'), input_ts, '\t');
dlmwrite(strcat('../../data/lab/pid/output_k=1_ti=200_td=5.csv'), output_ts, '\t');
dlmwrite(strcat('../../data/lab/pid/stpt_k=1_ti=200_td=5.csv'), stpt_ts, '\t');
disp([K Ti Td error_sum]);


load('pidK=20Ti=200Td=10.mat')
input_ts = [(1:length(input))' input];
output_ts = [(1:length(y))' y'];
stpt_ts = [(1:length(setpoint))' setpoint'];
dlmwrite(strcat('../../data/lab/pid/input_k=20_ti=200_td=10.csv'), input_ts, '\t');
dlmwrite(strcat('../../data/lab/pid/output_k=1_ti=200_td=10.csv'), output_ts, '\t');
dlmwrite(strcat('../../data/lab/pid/stpt_k=1_ti=200_td=10.csv'), stpt_ts, '\t');
disp([K Ti Td error_sum]);