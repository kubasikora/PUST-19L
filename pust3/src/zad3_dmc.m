clear
addpath ../

%% Definicja stalych
Upp = 0;
Ypp = 0;

Umin = -1;
Umax = 1;

T = 0.5;   
SIM_LEN = 1000;
U_SKOK = 1;

%% wyznaczenie odpowiedzi skokowej
u = (Upp + U_SKOK)*ones(SIM_LEN,1);
step = Ypp*ones(SIM_LEN,1);
for k = 7:SIM_LEN
    step(k) = symulacja_obiektu1y(u(k-5), u(k-6), step(k-1), step(k-2));
    %step(k) = 1.927*step(k-1)-0.9283*step(k-2)+0.04583*u(k-6);
end
cut_time = 0;
for i=2:SIM_LEN
    if (abs(step(i)-step(i-1)) == 0 && step(i) ~= 0)
        cut_time = i;
        break
    end
end
%step = step(1:cut_time);


%% parametry regulatora 
D = 303;
N = 50;
Nu = 10;
lambda = 10000;
zapis_do_pliku = 0;


%% inicjalizacja potrzebnych zmiennych
error_sum = 0;

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

for k=7:SIM_LEN    
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
    
    output(k) = symulacja_obiektu1y(input(k-5), input(k-6), output(k-1), output(k-2));  % pomiar wyjscia
    %output(k) = 1.927*output(k-1)-0.9283*output(k-2)+0.04583*input(k-6);
    rescaled_output = output(k) - Ypp;                                                      % skalowanie wyjscia   
    stpt = setpoint(k) - Ypp;                                                               % przeskalowany setpoint
    error(k) = stpt - rescaled_output;                                                      % obliczenie uchyby   
    
    error_sum = error_sum + error(k)^2;                                                     % wskaznik jakosci
    
    rescaled_input(k) = Ke * error(k) - Ku * dUp;
    rescaled_input(k) = rescaled_input(k-1) + rescaled_input(k);
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

if zapis_do_pliku == 1
    str = strcat('D_', num2str(D), '_N_', num2str(N), '_Nu_', num2str(Nu), '_lam_', num2str(lambda));
    disp(str)
    input_ts = [sim_time-1 input];
    output_ts = [sim_time-1 output];
    setpoint_ts = [sim_time-1 setpoint];
    dlmwrite(strcat('../data/project/zad4/zad4DMC_input_', str, '.csv'), input_ts, '\t');
    dlmwrite(strcat('../data/project/zad4/zad4DMC_output_', str, '.csv'), output_ts, '\t');
    dlmwrite(strcat('../data/project/zad4/zad4DMC_setpoint_', str, '.csv'), setpoint_ts, '\t');
end