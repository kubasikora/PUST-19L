t = 1:100;
x = 0.002*t.^2;

x1 = awgn(x, 20);
x2 = awgn(x, 10);
x3 = awgn(x, 0);
x4 = awgn(x, -10);


hold on
plot(t,x1);
plot(t,x2);
plot(t,x3);plot(t,x4);

to_save = [t' x1'];
dlmwrite(strcat('../data/zad7/awgn20.csv'), to_save, '\t');

to_save = [t' x2'];
dlmwrite(strcat('../data/zad7/awgn10.csv'), to_save, '\t');

to_save = [t' x3'];
dlmwrite(strcat('../data/zad7/awgn0.csv'), to_save, '\t');

to_save = [t' x4'];
dlmwrite(strcat('../data/zad7/awgn-10.csv'), to_save, '\t');