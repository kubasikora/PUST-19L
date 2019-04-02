%szybki skrypt do zad3
s1 = step(tf11);
s1_ts = [(1:length(s1))' s1];
dlmwrite(strcat('data/lab/zad3/apro_3_sz.csv'), s1_ts, '\t');
