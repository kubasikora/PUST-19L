clear all
load('lab3_pid.mat');

figure(1)
hold on
plot(y);
plot(setpoint);
hold off

figure(2)
plot(input);

input_ts = [(1:length(input))' input];
output_ts = [(1:length(y))' y'];
stpt_ts = [(1:length(setpoint))' setpoint'];

dlmwrite(strcat('../data/lab/zad3/pid_input.csv'), input_ts, '\t');
dlmwrite(strcat('../data/lab/zad3/pid_output.csv'), output_ts, '\t');
dlmwrite(strcat('../data/lab/zad3/pid_stpt.csv'), stpt_ts, '\t');