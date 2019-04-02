%szybki skrypt do zad3
s1 = step(tf3_do_3)%plot(norm_do_wykresu); % tu powinien byæ step
s1_ts = [(1:length(s1))' s1];
dlmwrite(strcat('data/lab/zad3/apro_3_sz.csv'), s1_ts, '\t');