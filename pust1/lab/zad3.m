%% wczytanie funkcji symulującej i inicjalizacja symulacji
Upp = 26;
Ypp = 34.5;
load('skok_o_-10.mat');
output = y';
deltaU = -10;
time = (1:length(output))';

%% normalizacja odpowiedzi skokowej
output = output - Ypp;
output = output / deltaU;

time =time(1:500,1);
output = output(1:500,1);

%% zapisanie znormalizowanej odpowiedzi skokowej
norm_resp = [time output];
plot(time, output);
dlmwrite("../data/lab/zad3_cut_odp.csv", norm_resp, '\t');