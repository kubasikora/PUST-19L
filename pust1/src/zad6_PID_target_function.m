%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Projektowanie uk�ad�w sterowania
%          Projekt 1, zadanie 6
%
%   Program b�d�cy funkcj� celu w procesie 
%   optymalizacji parametr�w regulatora PID
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function error_sum = zad6_PID_target_function(parameters)

addpath ../
%% inicjalizacja wskaznika jakosci oraz stalych w programie
error_sum = 0;

Upp = 0.5;
Ypp = 4;
Umin = 0.3;
Umax = 0.7;
dUmax = 0.05;
sim_len = 600;
T = 0.5; 

%% inicjalizacja potrzebnych wektorow sygnalow procesowych
% wartosc zadana
% stpt_value = 4.2;
% setpoint = stpt_value*ones(sim_len,1);
stpt_value_1 = 4.15;
stpt_value_2 = 3.91;
stpt_value_3 = 4.3;
setpoint = stpt_value_1*ones(sim_len,1);%[(stpt_value_1*ones(sim_len/3,1))' (stpt_value_2*ones(sim_len/3,1))' (stpt_value_3*ones(sim_len/3,1))']';
setpoint(1:11) = Ypp;

% wektor sygnalu sterujacego
input = Upp*ones(sim_len, 1);

% wektor wyjscia
output = Ypp*ones(sim_len, 1);

% wektor uchybu
error = zeros(sim_len, 1);

rescaled_input = zeros(sim_len, 1);

%% Definicja parametrow ciaglych regulatora PID przeslanych jako argument funkcji
K = parameters(1);
Ti = parameters(2);
Td = parameters(3);

%% Definicja wspolczynnikow regulatora cyfrowego
r0 = K*(1 + T/(2*Ti) + Td/T);
r1 = K*(T/(2*Ti) - (2*Td)/T - 1);
r2 = (K*Td)/T;

%% Petla symulujaca dzialanie cyfrowego algorytmu PID
for k = 12:sim_len    
    output(k) = symulacja_obiektu1Y(input(k-10), input(k-11), output(k-1), output(k-2));    % pomiar wyjscia
    rescaled_output = output(k) - Ypp;  % skalowanie wyjscia   
    stpt = setpoint(k) - Ypp;   % przeskalowany setpoint
    error(k) = stpt - rescaled_output;   % obliczenie uchybu
    
    error_sum = error_sum + error(k)^2; % suma bedaca wskaznikiem jakosci regulacji
    
    rescaled_input(k) = r2 * error(k-2) + r1 * error(k-1) + r0 * error(k) + rescaled_input(k-1);  % wyliczenie sterowania 

    % ograniczenia szybkosci zmian sterowania 
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
end