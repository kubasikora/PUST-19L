clear all
close all
addpath ../
addpath ./functions

SAVE = 0;
SIM_LEN = 1000;

%% parametry symulacji
T = 0.5;   
nu = 4;
ny = 3;

D = 40;
N = 20;
Nu = 5;
load('../data/project/zad2/zlozona_odp_skokowa.mat', 's');                 
s = s(1:D);

M = createMMatrix(N, Nu, s);
Mp = createMpMatrix(N, D, s);

% parametry optymalizacji
options = optimoptions('fmincon', 'Algorithm', 'sqp', 'Display', 'iter', 'MaxFunctionEvaluations', 2000);

lambda_min = 0.001*ones(1,nu);
lambda_max = 100000*ones(1,nu);

mi_min = 0.01*ones(1,ny);
mi_max = 10000*ones(1,ny);

base_values = [1000 100 100 100 100 100 100];

parameters = fmincon(@(parameters)dmcOptimTargetFun(parameters, D, N, Nu, M, Mp), base_values, [], [], [], [], [lambda_min mi_min], [lambda_max mi_max], [], options);

UPPs = [0; 0; 0; 0];
YPPs = [0; 0; 0];

lambda = parameters(1:4);
mi = parameters(5:7);

%% Inicjalizacja wektorow
% sterowania
inputs = ones(SIM_LEN, nu);
for i=1:nu
   inputs(:, i) = UPPs(i)*ones(SIM_LEN, 1); 
end
    
% wyjscia
outputs = ones(SIM_LEN, ny);
for i=1:ny
    outputs(:, i) = YPPs(i)*ones(SIM_LEN, 1);
end

% uchyby
errors = zeros(SIM_LEN, ny);

% wartosci zadane
setpoints = createSetpointTrajectory(SIM_LEN);

%% Generacja macierzy algorytmu DMC
M = createMMatrix(N, Nu, s);
Mp = createMpMatrix(N, D, s);
Lambda = createLambdaMatrix(Nu, lambda);
Psi = createPsiMatrix(N, mi);
dUp = zeros((D-1)*nu, 1);

K = inv(M'*Psi*M + Lambda)*((M')*Psi);
ke = evalKe(K, N, nu, ny);
ku = K(1,:)*Mp;

%% Petla symulujaca dzialanie cyfrowego algorytmu PID w wersji MIMO
for k = 5:SIM_LEN
    % wektor dUp
    for i = 1:(D-1)
        if (k-i) <= 0
            du1 = zeros(nu,1);
        else
            du1 = (inputs(k-i, :))';
        end
        if (k-i-1) <= 0
            du2 = zeros(nu,1);
        else
            du2 = (inputs(k-i-1, :))';
        end 
        dUp(1+(i-1)*nu:1+(i-1)*nu + (nu-1)) = du1 - du2;
    end
    
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
    inputs(k, :) = ke*((setpoints(k,:))' - (outputs(k,:))') - ku*dUp;
    
end

error_sum = zeros(ny,1);
for i=1:ny
    error_sum(i) = sum(errors(:, i).^2);
end

%% Wykresy sterowania oraz wyjscia
figure(1)
hold on
for i=1:ny
    subplot(ny,1,i), plot(1:SIM_LEN, setpoints(:, i), '--r', 1:SIM_LEN, outputs(:, i));
    title(strcat('Wyjście m=', num2str(i)));
end
hold off

figure(2)
hold on 
for i=1:nu
    subplot(nu,1, i), stairs(1:SIM_LEN, inputs(:, i));
    title(strcat('Sterowanie regulatora n=', num2str(i)));
end
hold off

if SAVE == 1
    while(1)
        dir_name = input('Podaj nazwę: ', 's');
        dir_name = strcat(dir_name, '/');
        base_name = strcat('../data/project/zad5/dmc/', dir_name);
        if exist(base_name, 'file')
            disp('Folder juz istnieje!');
            continue;
        end
        break;
    end
    
    DMC_PARAMS = [N; Nu];
    mkdir(base_name);
    dlmwrite(strcat(base_name, 'DMC_PARAMS.csv'), DMC_PARAMS, '\t');
    dlmwrite(strcat(base_name, 'LAMBDA.csv'), lambda, '\t');
    dlmwrite(strcat(base_name, 'MI.csv'), mi, '\t');
    dlmwrite(strcat(base_name, 'ERRORS.csv'), error_sum, '\t');
    dumpSimulation(base_name, nu, ny, outputs, inputs, setpoints, errors);
end
