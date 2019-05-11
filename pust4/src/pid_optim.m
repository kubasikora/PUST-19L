clear all
addpath ./functions

SAVE = 0;
SIM_LEN = 1000;

%% parametry symulacji
T = 0.5;   
M = 3;
N = 4;
CONNECTION_MATRIX = [1 0 0;
                     0 0 0;
                     0 1 0;
                     0 0 1];
                 
%% parametry optymalizacji
options = optimoptions('fmincon', 'Algorithm', 'sqp', 'Display', 'iter', 'MaxFunctionEvaluations', 2000);

K_min = 0.01*ones(1, N);
K_max = 10*ones(1, N);
Ti_min = 1*ones(1, N);
Ti_max = 100*ones(1, N);
Td_min = 0*ones(1, N);
Td_max = 10*ones(1, N);

base_values = [0.5 0.5 0.5 0.5 7.25 7.25 7.25 7.25 1.62 1.62 1.62 1.62];

parameters = fmincon(@(parameters)pidOptimTargetFun(parameters, CONNECTION_MATRIX, T), base_values, [], [], [], [], [K_min Ti_min Td_min], [K_max Ti_max Td_max], [], options);

UPPs = [0; 0; 0; 0];
YPPs = [0; 0; 0];

%% Inicjalizacja wektorow
% sterowania
inputs = ones(SIM_LEN, N);
for i=1:N
    inputs(:, i) = UPPs(i)*ones(SIM_LEN, 1);
end

% wyjscia
outputs = ones(SIM_LEN, M);
for i=1:M
    outputs(:, i) = YPPs(i)*ones(SIM_LEN, 1);
end

% uchyby
errors = zeros(SIM_LEN, M);

% wartosci zadane
setpoints = createSetpointTrajectory(SIM_LEN);

%% Parametry regulatorów ciągłych
K = parameters(1:N);
Ti = parameters(N+1:2*N);
Td = parameters(2*N + 1:end);


%% Parametry regulatorow dyskretnych
r0 = zeros(N,1);
r1 = zeros(N,1);
r2 = zeros(N,1);

for i=1:N
    r0(i) = K(i)*(1 + T/(2*Ti(i)) + Td(i)/T);
    r1(i) = K(i)*(T/(2*Ti(i)) - (2*Td(i))/T - 1);
    r2(i) = (K(i)*Td(i))/T;
end
    
%% Petla symulujaca dzialanie cyfrowego algorytmu PID w wersji MIMO
for k = 5:SIM_LEN  
     [y1, y2, y3] = symulacja_obiektu1(inputs(k-1, 1), inputs(k-2, 1), inputs(k-3, 1), inputs(k-4, 1), ...
                                       inputs(k-1, 2), inputs(k-2, 2), inputs(k-3, 2), inputs(k-4, 2), ...
                                       inputs(k-1, 3), inputs(k-2, 3), inputs(k-3, 3), inputs(k-4, 3), ...
                                       inputs(k-1, 4), inputs(k-2, 4), inputs(k-3, 4), inputs(k-4, 4), ...
                                       outputs(k-1, 1), outputs(k-2, 1), outputs(k-3, 1), outputs(k-4, 1), ...
                                       outputs(k-1, 2), outputs(k-2, 2), outputs(k-3, 2), outputs(k-4, 2), ...
                                       outputs(k-1, 3), outputs(k-2, 3), outputs(k-3, 3), outputs(k-4, 3));
    outputs(k, :) = [y1 y2 y3];                        
    errors(k, :) = setpoints(k, :) - outputs(k, :);   % obliczenie uchybów  

    % obliczenie nowych sterowan
    for i=1:N
        error = CONNECTION_MATRIX(i,:)*(errors(k-2:k, :)');
        inputs(k,i) = r2(i)*error(1) + r1(i)*error(2) + r0(i)*error(3) + inputs(k-1, i); 
    end
end

error_sum = zeros(M,1);
for i=1:M
    error_sum(i) = sum(errors(:, i).^2);
end

%% wykresy sterowania oraz wyjscia
figure(1)
hold on
for i=1:M
    subplot(M,1,i), plot(1:SIM_LEN, setpoints(:, i), '--r', 1:SIM_LEN, outputs(:, i));
    title(strcat('Wyjście m=', num2str(i)));
end
hold off

figure(2)
hold on 
for i=1:N
    subplot(N,1, i), stairs(1:SIM_LEN, inputs(:, i));
    title(strcat('Sterowanie regulatora n=', num2str(i)));
end
hold off

if SAVE == 1
    while(1)
        dir_name = input('Podaj nazwę: ', 's');
        dir_name = strcat(dir_name, '/');
        base_name = strcat('../data/project/zad5/pid/', dir_name);
        if exist(base_name, 'file')
            disp('Folder juz istnieje!');
            continue;
        end
        break;
    end
    
    PID_PARAMS = [K; Ti; Td];
    mkdir(base_name);
    dlmwrite(strcat(base_name, 'CONNECTION_MATRIX.csv'), CONNECTION_MATRIX, '\t');
    dlmwrite(strcat(base_name, 'PID_PARAMS.csv'), PID_PARAMS, '\t');
    dlmwrite(strcat(base_name, 'ERRORS.csv'), error_sum, '\t');
    dumpSimulation(base_name, N, M, outputs, inputs, setpoints, errors);
end