%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Projektowanie uk³adów sterowania
%          Projekt 1, zadanie 4
%
%   Program symuluj¹cy cyfrowy algorytm PID
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Dodanie sciezki ze skryptem symulujacym dzialanie obiektu

addpath ../

%% Definicja stalych

Upp = 0.5;
Ypp = 4;

Umin = 0.3;
Umax = 0.7;
dUmax = 0.05;

T = 0.5;   
sim_len = 500;

%% Inicjalizacja wektorow
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

%% Definicja parametrow ciaglych regulatora PID

K = 0.19;
Ti = 4.9;
Td = 0.088;

% zoptymalizowane parametry
% K = 0.20296;
% Ti = 4.9007;
% Td = 0.090366;

%% Definicja wspolczynnikow regulatora cyfrowego

r0 = K*(1 + T/(2*Ti) + Td/T);
r1 = K*(T/(2*Ti) - (2*Td)/T - 1);
r2 = (K*Td)/T;

%% Petla symulujaca dzialanie cyfrowego algorytmu PID
error_sum = 0;
for k = 12:sim_len    
    output(k) = symulacja_obiektu1Y(input(k-10), input(k-11), output(k-1), output(k-2));    % pomiar wyjscia
    rescaled_output = output(k) - Ypp;  % skalowanie wyjscia   
    stpt = setpoint(k) - Ypp;   % przeskalowany setpoint
    error(k) = stpt - rescaled_output;   % obliczenie uchyby   
    
    error_sum = error_sum + error(k)^2;
    
    rescaled_input(k) = r2 * error(k-2) + r1 * error(k-1) + r0 * error(k) + rescaled_input(k-1);  % wyliczenie sterowania 
  
    % ograniczenia  
    if rescaled_input(k) - rescaled_input(k-1) >= dUmax
        rescaled_input(k) = dUmax + input(k-1);
    elseif input(k) - rescaled_input(k-1) <= -dUmax
        rescaled_input(k) = rescaled_input(k-1) - dUmax;
    end   
    input(k) = input(k) + rescaled_input(k);
    if input(k) >= Umax
        input(k) = Umax;
    elseif input(k) <= Umin
        input(k) = Umin;
    end 
end

%% to sie moze przydac do generowania plikow z danymi (przesuwa wykres)
% przyciecie wektora wyjscia
% output = output(11:500);
% output(491:500) = output(490);

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
% input_ts = [sim_time-1 input];
% output_ts = [sim_time-1 output];
% dlmwrite("../data/zad4_PID_input_example.csv", input_ts, '\t');
% dlmwrite("../data/zad4_PID_output_example.csv", output_ts, '\t');
