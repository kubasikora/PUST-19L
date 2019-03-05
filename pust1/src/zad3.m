%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Projektowanie układów sterowania
%          Projekt 1, zadanie 1
%
%   Wyznaczenie znormalizowanej
%   odpowiedzi skokowej
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% wczytanie funkcji symulującej i inicjalizacja symulacji
addpath ../
Upp = 0.5;
Ypp = 4;
SIM_LEN = 200;
time = (1:SIM_LEN)';
deltaU = 0.1;
input = (Upp+deltaU)*ones(SIM_LEN,1);
output = Ypp*ones(SIM_LEN,1);

%% zebranie odpowiedzi skokowej obiektu
for k=12:SIM_LEN
    output(k) = symulacja_obiektu1Y(input(k-10), input(k-11), output(k-1), output(k-2));
end 


%% normalizacja odpowiedzi skokowej
output = output - Ypp;
output = output / deltaU;


%% zapisanie znormalizowanej odpowiedzi skokowej
norm_resp = [time-1 output];
plot(time-1, output);
dlmwrite("../data/zad3_norm_odp.csv", norm_resp, '\t');
