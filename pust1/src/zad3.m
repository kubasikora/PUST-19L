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
Ypp = 32;
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
norm_resp = [time output];
plot(time, output);
dlmwrite('../data/zad3_norm_odp_____________.csv', norm_resp, '\t');


%% obcięcie odpowiedzi skokowej
EPS = 0.0001;
cut_time = 0;
for i=2:SIM_LEN
    if (output(i)-output(i-1) < EPS && output(i) ~= 0)
        cut_time = i;
        break
    end
end

%% zapis obciętej odpowiedzi skokowej
cut_time_vect = transpose(1:(cut_time));
cut_response = output(1:cut_time);
plot(cut_time_vect, cut_response);
cut_resp = [cut_time_vect cut_response];
dlmwrite('../data/zad3_cut_norm_odp.csv', cut_resp, '\t');