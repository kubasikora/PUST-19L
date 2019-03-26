%close all;
clear all;
addpath ../

%% wczytanie wektorow znormalizowanych odp skokowych
step = importdata('../data/zad3/zad3_input_cut_response.csv');
step_d = importdata('../data/zad3/zad3_disturbance_cut_response.csv');
step = step(:, 2);
step_d = step_d(:, 2);

%% parametry regulatora 
D = 155;
N = 70;  
Nu = 1;
lambda = 0.01;

Dz = 147;

%% uwzglednienie zaklocen
disturb = 0;    % uwzglednienie zaklocenia
do_disturb = 0; % flaga do realizacji skoku zaklocenia
do_sine = 0;    % wlaczenie zaklocenia sinusoidalnego

%% Definicja stalych
Upp = 0;
Ypp = 0;
Dpp = 0;

T = 0.5;   
sim_len = 500;
eps = 0.001;

%% inicjalizacja potrzebnych zmiennych
error_sum = 0;

% czas symulacji
sim_time = 1:sim_len;
sim_time = sim_time';

% wartosc zadana
stpt_value = 1;
setpoint = stpt_value * ones(sim_len,1);

% wektor sygnalu sterujacego
input = Upp*ones(sim_len, 1);

% wektor wyjscia
output = Ypp*ones(sim_len, 1);

% zaklocenia
disturbance = Dpp*ones(sim_len,1);

% przeskalowane sygnaly
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

%% macierze zwiazane z zakloceniami
dDp = zeros(Dz, 1);
Mzp = zeros(N, Dz);

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

% macierz Mzp
if disturb == 1
    do_disturb = 1;
    for i = 1:Dz
        if i == 1            
            for j = 1:N
                k = j;
                if k > Dz
                    k = Dz;
                end
                Mzp(j, i) = step_d(k);
            end
        else
            for j = 1:N
                k = i + j - 1;
                if k > Dz
                    Mzp(j,i) = step_d(Dz) - step_d(i-1);
                else
                    Mzp(j,i) = step_d(k) - step_d(i-1);
                end
            end
        end
    end
end

%% symulacja
Ke = sum(K(1,:));

for k=8:sim_len    
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
    
    output(k) = symulacja_obiektu1y(input(k-6), input(k-7), disturbance(k-2), disturbance(k-3), output(k-1), output(k-2));
    rescaled_output = output(k) - Ypp;                                                    
    stpt = setpoint(k) - Ypp;                                                             
    error(k) = stpt - rescaled_output;  
    error_sum = error_sum + error(k)^2;
    
    if do_disturb == 1 && error(k) < eps 
        if do_sine == 1
            n = length(disturbance(k:end));
            x = 0:pi/n:2*pi;
            x = x(1:n);            
            disturbance(k:end) = sin(4*x);
        else
            disturbance(k:end) = 1;
        end
        jump = k;
        do_disturb = 0;
    end    
    
    if disturb == 1
        % wektor dZ
        for i = 1:Dz            
            if (k-i+1) <= 0
                dd1 = 0;
            else
                dd1 = disturbance(k - i + 1);
            end
            if (k-i) <= 0
                dd2 = 0;
            else
                dd2 = disturbance(k - i);
            end             
            dDp(i) = dd1 - dd2;
        end           
        rescaled_input(k) = Ke * error(k) - K(1,:) * (Mp * dUp + Mzp * dDp);
    else
        rescaled_input(k) = Ke * error(k) - K(1,:) * Mp * dUp;
    end
    
    rescaled_input(k) = rescaled_input(k-1) + rescaled_input(k);
    input(k) = input(k) + rescaled_input(k);
    
end

%% wykresy sterowania oraz wyjscia
figure(1)
stairs(sim_time, input);
hold on 
grid on
title('Sterowanie');
hold off

figure(2)
plot(sim_time, setpoint);
hold on
grid on
plot(sim_time, output);
title(['Wyjscie, E = ' num2str(error_sum)]);
hold off

figure(3)
stairs(sim_time, disturbance);
hold on
grid on
title('Zaklocenie');
hold off

% if disturb == 0 && do_disturb == 0
%     %% zapis do plikow: ZADANIE 4.
     str = strcat('N_', num2str(N), '_Nu_', num2str(Nu), '_lambda_', num2str(lambda));
     disp(str)
 
     input_ts = [sim_time-1 input];
     output_ts = [sim_time-1 output];
     setpoint_ts = [sim_time-1 setpoint];
 
     dlmwrite(strcat('../data/zad4/zad4_input_', str, '.csv'), input_ts, '\t');
     dlmwrite(strcat('../data/zad4/zad4_output_', str, '.csv'), output_ts, '\t');
     dlmwrite(strcat('../data/zad4/zad4_stpt_', str, '.csv'), setpoint_ts, '\t');
% else
%     %% zapis do plikow: ZADANIE 5.
%      str = strcat('N_', num2str(N), '_Nu_', num2str(Nu), '_lambda_', num2str(lambda), '_D_jump_', num2str(jump));
%      disp(str)
%      
%      input_ts = [sim_time-1 input];
%      output_ts = [sim_time-1 output];
%      setpoint_ts = [sim_time-1 setpoint];
%      disturbance_ts = [sim_time-1 disturbance];
%      
%      dlmwrite(strcat('../data/zad4/zad5_input_', str, '.csv'), input_ts, '\t');
%      dlmwrite(strcat('../data/zad5/zad5_output_', str, '.csv'), output_ts, '\t');
%      dlmwrite(strcat('../data/zad5/zad5_stpt_', str, '.csv'), setpoint_ts, '\t');
%     dlmwrite(strcat('../data/zad5/zad5_disturbance_', str, '.csv'), disturbance_ts, '\t');
% end