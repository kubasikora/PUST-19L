%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Projektowanie uk�ad�w sterowania
%          Projekt 1, zadanie 6
%
%   Program b�d�cy funkcj� celu w procesie 
%   optymalizacji parametr�w regulatora DMC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function error_sum = zad6_DMC_target_function(parameters)
addpath ../
floor(parameters(1));
floor(parameters(2));

%% wczytanie wektora znormalizowanej odp skokowej
step = importdata('../data/zad3_cut_norm_odp.csv');
step = step(:, 2);

%% inicjalizacja wskaznika jakosci oraz stalych w programie
error_sum = 0;

D = 91;
Upp = 0.5;
Ypp = 4;
Umin = 0.3;
Umax = 0.7;
dUmax = 0.05;
sim_len = 900;
T = 0.5; 

%% inicjalizacja potrzebnych wektorow sygnalow procesowych
% wartosc zadana
% wartosc zadana
stpt_value_1 = 4.15;
stpt_value_2 = 3.91;
stpt_value_3 = 4.3;
setpoint = [(stpt_value_1*ones(sim_len/3,1))' (stpt_value_2*ones(sim_len/3,1))' (stpt_value_3*ones(sim_len/3,1))']';
setpoint(1:11) = Ypp;

% wektor sygnalu sterujacego
input = Upp*ones(sim_len, 1);

% wektor wyjscia
output = Ypp*ones(sim_len, 1);

% wektor uchybu
error = zeros(sim_len, 1);

% skalowane sygnaly
rescaled_output = 0;
rescaled_input = zeros(sim_len, 1);

%% Definicja parametrow regulatora DMC przeslanych jako argument funkcji
N = floor(parameters(1));
Nu =floor(parameters(2));
lambda = parameters(3);

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

% macierz K
K = inv((M' * M + lambda * eye(Nu)))*M';

%% Petla symulujaca dzialanie cyfrowego algorytmu DMC
Ke = sum(K(1,:));
Ku = K(1,:) * Mp;
for k = 12:sim_len
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
%     if rescaled_input(k) - rescaled_input(k-1) >= dUmax
%         rescaled_input(k) = dUmax + rescaled_input(k-1);
%     elseif rescaled_input(k) - rescaled_input(k-1) <= -dUmax
%         rescaled_input(k) = rescaled_input(k-1) - dUmax;
%     end   
    
    input(k) = input(k) + rescaled_input(k);  
    
%     if input(k) >= Umax
%         input(k) = Umax;
%     elseif input(k) <= Umin
%         input(k) = Umin;
%     end 
end
end