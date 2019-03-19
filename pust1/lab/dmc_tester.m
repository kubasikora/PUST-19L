addpath ../

%% wczytanie wektora znormalizowanej odp skokowej
step = importdata('norm_odp_skok.mat');
step = step.output;
%step = step(:, 2);

%% parametry regulatora 
% D = 91;
% % N = D;  % pkt startowy do strojenia
% % Nu = N;
% % lambda = 10;
% 
% %% parametry otrzymane w wyniku optymalizacji funkcja gradientowa
% N = 40;
% Nu = 5;
% lambda = 1;
% 
% N = floor(27.483);
% Nu = floor(4.4078);
% lambda = 0.016859;
% 
% N = floor(39.7583);
% Nu = floor(1.8752);
% lambda = 78.1327;
% 
% N = round(21.6692);
% Nu = round(1.9447);
% lambda = 0.76823;

%% Parametry reguratora na labki
D = 500;
N = 140; 
Nu = 1; 
lambda = 50;

%% Definicja stalych
Upp = 26;
Ypp = 34.5;

Umin = 0;
Umax = 100;
%dUmax = 0.05;
T = 1;   
sim_len = 1400;

%% inicjalizacja potrzebnych zmiennych
error_sum = 0;

% czas symulacji
sim_time = 1:sim_len; % do plotowania
sim_time = sim_time';

% wartosc zadana
stpt_value_1 = 40;
stpt_value_2 = stpt_value_1;
stpt_value_3 = stpt_value_1;
setpoint(12:1400) = stpt_value_1;%[(stpt_value_1*ones(sim_len/3,1))' (stpt_value_2*ones(sim_len/3,1))' (stpt_value_3*ones(sim_len/3,1))']';
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

% macierz K
K = inv((M' * M + lambda * eye(Nu)))*M';

%% symulacja
Ke = sum(K(1,:));
Ku = K(1,:) * Mp;

for k=15:sim_len    
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
    
    output(k) = symulacjaObiektuCH_G(input(k-13), input(k-14), output(k-1), output(k-2));    % pomiar wyjscia by³o input(k-10), input(k-11)
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

%% zapis do plikow
% wypisanie wartosci wspolczynnikow 
str = strcat('N_', num2str(N), '_Nu_', num2str(Nu), '_lambda_', num2str(lambda));
disp(str)
% input_ts = [sim_time-1 input];
% output_ts = [sim_time-1 output];
% setpoint_ts = [sim_time-1 setpoint];
% dlmwrite(strcat('../data/zad6_multiplejumps/DMC/opt_DMC_input_', str, '.csv'), input_ts, '\t');
% dlmwrite(strcat('../data/zad6_multiplejumps/DMC/opt_DMC_output_', str, '.csv'), output_ts, '\t');
% dlmwrite(strcat('../data/zad6_multiplejumps/DMC/opt_DMC_stpt_', str, '.csv'), setpoint_ts, '\t');
