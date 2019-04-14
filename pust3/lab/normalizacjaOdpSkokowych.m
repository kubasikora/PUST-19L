hold on

clear all
load('lab5_skokz35do40.mat')

Ypp = y(1);
dU = 5;
y_norm = (y - Ypp)/dU;


plot(y_norm);
save('lab5_skokz35do40_norm.mat')



clear all
load('lab5_skokz50do55.mat')

Ypp = y(1);
dU = 5;
y_norm = (y - Ypp)/dU;


plot(y_norm);
save('lab5_skokz50do55_norm.mat')


clear all
load('lab5_skokz65do70.mat')

Ypp = y(1);
dU = 5;
y_norm = (y - Ypp)/dU;


plot(y_norm);
save('lab5_skokz65do70_norm.mat')

hold off