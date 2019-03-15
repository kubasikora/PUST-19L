%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Projektowanie uk�ad�w sterowania
%          Projekt 1, zadanie 4
%
%   Program symuluj�cy cyfrowy algorytm PID
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
sim_len = 600;

%% Inicjalizacja wektorow
% czas symulacji
sim_time = 1:sim_len; % do plotowania
sim_time = sim_time';

% wartosc zadana
stpt_value_1 = 4.15;
stpt_value_2 = 3.91;
stpt_value_3 = 4.3;
setpoint = [(stpt_value_1*ones(sim_len/3,1))' (stpt_value_2*ones(sim_len/3,1))' (stpt_value_3*ones(sim_len/3,1))']';
setpoint(1:11) = Ypp;
 
% setpoint(200:350)=3.8;
% setpoint(351:500)=4;
% % setpoint(301:400)=4;


% wektor sygnalu sterujacego
input = Upp*ones(sim_len, 1);

% wektor wyjscia
output = Ypp*ones(sim_len, 1);

rescaled_output = 0;
rescaled_input = zeros(sim_len, 1);

% wektor uchybu
error = zeros(sim_len, 1);

% Definicja parametrow ciaglych regulatora PID

% K = 0.38*0.45;
% Ti = 5.2007;%1000000;
% Td = 0.090366;true

K = 0.5;
Ti = 6.25;
Td = 1.62; 

K = 1.1497;
Ti = 6.9813;
Td = 2.151;

save_file = false;
save_file_zad6 = false;
% K = 0.19;
% Ti = 4.9;
% Td = 0.088;

% zoptymalizowane parametry

% K = 0.19578;
% Ti = 6.9997;
% Td = 0.1206;

% K = 0.23125;
% Ti = 5.0018;
% Td = 0.015538;


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
  
    %ograniczenia  
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

% zapis do plikow
% wypisanie wartosci wspolczynnikow 
str = strcat('K_', num2str(K), '_Ti_', num2str(Ti), '_Td_', num2str(Td), '_E_', num2str(error_sum));
disp(str)
disp(error_sum)

if(save_file)
    input_ts = [sim_time-1 input];
    output_ts = [sim_time-1 output];
    setpoint_ts = [sim_time-1 setpoint];
    dlmwrite(strcat('../data/zad5_multiplejumps/D/zad5_PID_input_example', str, '.csv'), input_ts, '\t');
    dlmwrite(strcat('../data/zad5_multiplejumps/D/zad5_PID_output_example', str, '.csv'), output_ts, '\t');
    dlmwrite(strcat('../data/zad5_multiplejumps/D/zad5_PID_setpoint_example', str, '.csv'), setpoint_ts, '\t');
end


if(save_file_zad6)
    input_ts = [sim_time-1 input];
    output_ts = [sim_time-1 output];
    setpoint_ts = [sim_time-1 setpoint];
    dlmwrite(strcat('../data/zad6_multiplejumps/PID/zad6_PID_input_example', str, '.csv'), input_ts, '\t');
    dlmwrite(strcat('../data/zad6_multiplejumps/PID/zad6_PID_output_example', str, '.csv'), output_ts, '\t');
    dlmwrite(strcat('../data/zad6_multiplejumps/PID/zad6_PID_setpoint_example', str, '.csv'), setpoint_ts, '\t');
end