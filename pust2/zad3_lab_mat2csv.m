%szybki skrypt do zad3
s1 = step(data_3_pomiar_s);
s1_ts = [(1:length(s1))' s1];
dlmwrite(strcat('data/lab/zad3/apro_3_s.csv'), s1_ts, '\t');
