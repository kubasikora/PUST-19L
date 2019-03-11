addpath ../

%% wczytanie wektora znormalizowanej odp skokowej
step = importdata('../data/zad3_cut_norm_odp.csv');
step = step(:, 2);

%% parametry regulatora 
D = 91;
N = 25;
Nu = 5;
lambda = 10;

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
        k = i + j;
        if k > D
            Mp(i,j) = step(D) - step(j);
        else
            Mp(i,j) = step(k) - step(j);
        end
    end
end
A = M' * M;
B = lambda * eye(Nu);
C = M';

% macierz K
K = (A + B)*C;

%% symulacja
Ke = sum(K(1,:));
Ku = K(1,:) * Mp;

for k=12:sim_len    
    % wektor dUp
    for i = 1:(D-1)
        if (k-i) <= 0
            du1 = 0;
        else
            du1 = rescaled_input(k - i);
        end
        if (k-i-1) <= 0
            du2 = 0;
        else
            du2 = rescaled_input(k - i - 1);
        end 
        dUp(i) = du1 - du2;
    end
    
    output(k) = symulacja_obiektu1Y(input(k-10), input(k-11), output(k-1), output(k-2));    % pomiar wyjscia
    rescaled_output = output(k) - Ypp;                                                      % skalowanie wyjscia   
    stpt = setpoint(k) - Ypp;                                                               % przeskalowany setpoint
    error(k) = stpt - rescaled_output;                                                      % obliczenie uchyby   
    
    error_sum = error_sum + error(k)^2;                                                     % wskaznik jakosci
    
    rescaled_input(k) = Ke * error(k) - Ku * dUp;
    rescaled_input(k) = rescaled_input(k-1) + rescaled_input(k);
    
    % ograniczenia  
    if rescaled_input(k) - rescaled_input(k-1) >= dUmax
        rescaled_input(k) = dUmax + rescaled_input(k-1);
    elseif rescaled_input(k) - rescaled_input(k-1) <= -dUmax
        rescaled_input(k) = rescaled_input(k-1) - dUmax;
    end   
    
    input(k) = input(k) + rescaled_input(k);  
    
    if input(k) >= Umax
        input(k) = Umax;
    elseif input(k) <= Umin
        input(k) = Umin;
    end 
end

%% wykresy sterowania oraz wyjscia
figure(1)
stairs(sim_time, input);
hold on 
title('Sterowanie');
hold off

figure(2)
plot(sim_time, setpoint);
hold on
plot(sim_time, output);
title(['Wyjscie, E = ' num2str(error_sum)]);
hold off

