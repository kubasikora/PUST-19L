clear;

nr_proby = 'PID\PROBA3';

load(strcat(nr_proby, '.mat'));
stpt1 = stpt1./100;
stpt2 = stpt2./100;
stpt_temp = [];

for i=1:size(stpt1)
   for j=1:4
        stpt_temp(4*i+j-4,1) =  stpt1(i,1);
   end
end
stpt1 = stpt_temp;

for i=1:size(stpt2)
   for j=1:4
        stpt_temp(4*i+j-4,1) =  stpt2(i,1);
   end
end
stpt2 = stpt_temp;

output_ts_1 = [(1:length(y1))' y1];
output_ts_2 = [(1:length(y2))' y2];

input_ts_1 = [(1:length(u1))' u1];
input_ts_2 = [(1:length(u2))' u2];

stpt_ts_1 = [(1:length(stpt1))' stpt1];
stpt_ts_2 = [(1:length(stpt2))' stpt2];

dlmwrite(strcat(nr_proby, 'output_1.csv'), output_ts_1, '\t');
dlmwrite(strcat(nr_proby, 'output_2.csv'), output_ts_2, '\t');

dlmwrite(strcat( nr_proby, 'input_1.csv'), input_ts_1, '\t');
dlmwrite(strcat( nr_proby, 'input_2.csv'), input_ts_2, '\t');

dlmwrite(strcat( nr_proby, 'stpt_1.csv'), stpt_ts_1, '\t');
dlmwrite(strcat( nr_proby, 'stpt_2.csv'), stpt_ts_2, '\t');