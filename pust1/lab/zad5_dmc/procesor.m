load('dmcN=100Nu=100l=100.mat')
input_ts = [(1:length(input))' input];
output_ts = [(1:length(y))' y'];
stpt_ts = [(1:length(setpoint))' setpoint'];
dlmwrite(strcat('../../data/lab/dmc/input_N=100Nu=100l=100.csv'), input_ts, '\t');
dlmwrite(strcat('../../data/lab/dmc/output_N=100Nu=100l=100.csv'), output_ts, '\t');
dlmwrite(strcat('../../data/lab/dmc/stpt_N=100Nu=100l=100.csv'), stpt_ts, '\t');
disp([N Nu lambda error_sum]);


load('dmcN=200Nu=200l=100.mat')
input_ts = [(1:length(input))' input];
output_ts = [(1:length(y))' y'];
stpt_ts = [(1:length(setpoint))' setpoint'];
dlmwrite(strcat('../../data/lab/dmc/input_N=200Nu=200l=100.csv'), input_ts, '\t');
dlmwrite(strcat('../../data/lab/dmc/output_N=200Nu=200l=100.csv'), output_ts, '\t');
dlmwrite(strcat('../../data/lab/dmc/stpt_N=200Nu=200l=100.csv'), stpt_ts, '\t');
disp([N Nu lambda error_sum]);


load('dmcN=140Nu=140l=100.mat')
input_ts = [(1:length(input))' input];
output_ts = [(1:length(y))' y'];
stpt_ts = [(1:length(setpoint))' setpoint'];
dlmwrite(strcat('../../data/lab/dmc/input_N=140Nu=140l=100.csv'), input_ts, '\t');
dlmwrite(strcat('../../data/lab/dmc/output_N=140Nu=140l=100.csv'), output_ts, '\t');
dlmwrite(strcat('../../data/lab/dmc/stpt_N=140Nu=140l=100.csv'), stpt_ts, '\t');
disp([N Nu lambda error_sum]);


load('dmcN=140Nu=40l=100.mat')
input_ts = [(1:length(input))' input];
output_ts = [(1:length(y))' y'];
stpt_ts = [(1:length(setpoint))' setpoint'];
dlmwrite(strcat('../../data/lab/dmc/input_N=140Nu=40l=100.csv'), input_ts, '\t');
dlmwrite(strcat('../../data/lab/dmc/output_N=140Nu=40l=100.csv'), output_ts, '\t');
dlmwrite(strcat('../../data/lab/dmc/stpt_N=140Nu=40l=100.csv'), stpt_ts, '\t');
disp([N Nu lambda error_sum]);


load('dmcN=140Nu=10l=100.mat')
input_ts = [(1:length(input))' input];
output_ts = [(1:length(y))' y'];
stpt_ts = [(1:length(setpoint))' setpoint'];
dlmwrite(strcat('../../data/lab/dmc/input_N=140Nu=10l=100.csv'), input_ts, '\t');
dlmwrite(strcat('../../data/lab/dmc/output_N=140Nu=10l=100.csv'), output_ts, '\t');
dlmwrite(strcat('../../data/lab/dmc/stpt_N=140Nu=10l=100.csv'), stpt_ts, '\t');
disp([N Nu lambda error_sum]);


load('dmcN=140Nu=1l=100.mat')
input_ts = [(1:length(input))' input];
output_ts = [(1:length(y))' y'];
stpt_ts = [(1:length(setpoint))' setpoint'];
dlmwrite(strcat('../../data/lab/dmc/input_N=140Nu=1l=100.csv'), input_ts, '\t');
dlmwrite(strcat('../../data/lab/dmc/output_N=140Nu=1l=100.csv'), output_ts, '\t');
dlmwrite(strcat('../../data/lab/dmc/stpt_N=140Nu=1l=100.csv'), stpt_ts, '\t');
disp([N Nu lambda error_sum]);

load('dmcN=140Nu=1l=80.mat')
input_ts = [(1:length(input))' input];
output_ts = [(1:length(y))' y'];
stpt_ts = [(1:length(setpoint))' setpoint'];
dlmwrite(strcat('../../data/lab/dmc/input_N=140Nu=1l=80.csv'), input_ts, '\t');
dlmwrite(strcat('../../data/lab/dmc/output_N=140Nu=1l=80.csv'), output_ts, '\t');
dlmwrite(strcat('../../data/lab/dmc/stpt_N=140Nu=1l=80.csv'), stpt_ts, '\t');
disp([N Nu lambda error_sum]);

load('dmcN=140Nu=1l=50.mat')
input_ts = [(1:length(input))' input];
output_ts = [(1:length(y))' y'];
stpt_ts = [(1:length(setpoint))' setpoint'];
dlmwrite(strcat('../../data/lab/dmc/input_N=140Nu=1l=50.csv'), input_ts, '\t');
dlmwrite(strcat('../../data/lab/dmc/output_N=140Nu=1l=50.csv'), output_ts, '\t');
dlmwrite(strcat('../../data/lab/dmc/stpt_N=140Nu=1l=50.csv'), stpt_ts, '\t');
disp([N Nu lambda error_sum]);


load('dmcN=140Nu=1l=10.mat')
input_ts = [(1:length(input))' input];
output_ts = [(1:length(y))' y'];
stpt_ts = [(1:length(setpoint))' setpoint'];
dlmwrite(strcat('../../data/lab/dmc/input_N=140Nu=1l=10.csv'), input_ts, '\t');
dlmwrite(strcat('../../data/lab/dmc/output_N=140Nu=1l=10.csv'), output_ts, '\t');
dlmwrite(strcat('../../data/lab/dmc/stpt_N=140Nu=1l=10.csv'), stpt_ts, '\t');
disp([N Nu lambda error_sum]);