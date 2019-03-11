addpath ../

%% wczytanie wektora znormalizowanej odp skokowej
step = importdata('../data/zad3_cut_norm_odp.csv');
step = step(:, 2);

%% parametry regulatora 
D = 91;
N = 20;
Nu = 20;
lambda = 0;

%% Definicja stalych
Upp = 0.5;
Ypp = 4;

Umin = 0.3;
Umax = 0.7;
dUmax = 0.05;
T = 0.5;   
sim_len = 500;

%% inicjalizacja potrzebnych zmiennych
error_sum = 0;

% czas symulacji
sim_time = 1:sim_len; % do plotowania
sim_time = sim_time';

% wartosc zadana
stpt_value = 4.2;
setpoint = stpt_value*ones(sim_len,1);
setpoint(1:11) = Ypp;

% wektor sygnalu sterujacego
input = Upp*ones(sim_len, 1);

% wektor wyjscia
output = Ypp*ones(sim_len, 1);

rescaled_output = 0;
rescaled_input = zeros(sim_len, 1);

% wektor uchybu
error = zeros(sim_len, 1);

%% inicjalizacja macierzy algorytmu
dU = zeros(Nu, 1);
dUp = zeros(D-1, 1);
M = zeros(N, Nu);
Mp = zeros(N, D-1);
K = zeros(Nu, N);

%% wyliczenie macierzy 
% macierz M
for i = 1:Nu
    k = 1;
    for j = 1:N
        if j < i
            M(j, i) = 0;
        else
            M(j, i) = step(k);
            k = k + 1;
        end
    end
end

% macierz Mp
for i = 1:N
    for j = 1:(D-1)
        k = 
    end
end



