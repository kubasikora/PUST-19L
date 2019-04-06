%% Dodanie sciezki ze skryptem symulujacym dzialanie obiektu

addpath ../


%% Definicja stalych

Upp = 0;
Ypp = 0;

Umin = -1;
Umax = 1;

T = 0.5;   
SIM_LEN = 3000;

%% Inicjalizacja wektorow
% czas symulacji
sim_time = 1:SIM_LEN; % do plotowania
sim_time = sim_time';

% wartosc zadana
setpoint = createSetpointTrajectory(SIM_LEN);

% wektor sygnalu sterujacego
input = Upp*ones(SIM_LEN, 1);

% wektor wyjscia
output = Ypp*ones(SIM_LEN, 1);

rescaled_output = 0;
rescaled_input = zeros(SIM_LEN, 1);

% wektor uchybu
error = zeros(SIM_LEN, 1);

% Definicja parametrow ciaglych regulatora PID

K = 0.01;
Ti = 84;
Td = 0.01;

%% Definicja wspolczynnikow regulatora cyfrowego

r0 = K*(1 + T/(2*Ti) + Td/T);
r1 = K*(T/(2*Ti) - (2*Td)/T - 1);
r2 = (K*Td)/T;

%% Petla symulujaca dzialanie cyfrowego algorytmu PID
error_sum = 0;
for k = 12:SIM_LEN     
    output(k) = symulacja_obiektu1y(input(k-10), input(k-11), output(k-1), output(k-2));    % pomiar wyjscia
    rescaled_output = output(k) - Ypp;  % skalowanie wyjscia   
    stpt = setpoint(k) - Ypp;   % przeskalowany setpoint
    error(k) = stpt - rescaled_output;   % obliczenie uchyby   
    
    error_sum = error_sum + error(k)^2;
    
    rescaled_input(k) = r2 * error(k-2) + r1 * error(k-1) + r0 * error(k) + rescaled_input(k-1);  % wyliczenie sterowania    
    input(k) = input(k) + rescaled_input(k);
    
    if input(k) >= Umax
        input(k) = Umax;
    elseif input(k) <= Umin
        input(k) = Umin;
    end 
end
figure(2)
plot(sim_time, setpoint);
hold on
plot(sim_time, output);
title(['Wyjscie, E = ' num2str(error_sum)]);
hold off

%% wykresy sterowania oraz wyjscia
figure(1)
stairs(sim_time, input);
hold on 
title('Sterowanie');
hold off

