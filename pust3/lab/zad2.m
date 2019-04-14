clear all
inputs = [20 30 40 50 60 70 80];
y_total = [];
outputs= zeros(7,1);

for i=1:7
   name = strcat('lab2_', num2str(inputs(i)), '.mat');
   load(name);
   outputs(i) = y(k);
   y_total = [y_total y];
end

plot(inputs, outputs);
char_stat_ts = [inputs' outputs];
dlmwrite(strcat('../data/lab/zad2/char_stat.csv'), char_stat_ts, '\t');
