close all
clear all
addpath ../
addpath functions/

%% Parametry skryptu
SAVE = 1;
SIM_LEN = 1000;

%% Parametry regulatora
D = 200;
N = 20;
Nu = 5;
lambda = [10 5 1 1];
mi = [3.1 1.2 11.8];

load('../data/project/zad2/zlozona_odp_skokowa.mat', 's');
s = s(1:D);

%% Definicja stalych
T = 0.5;   
ny = 3;
nu = 4;

UPPs = [0; 0; 0; 0];
YPPs = [0; 0; 0];
  
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

K = inv( (M') * Psi * M + Lambda )* ( (M') * Psi );
K1 = K(1:nu, :);
ke = evalKe(K, N, nu, ny);

Mp_cell = cell(1, D-1);
for j=1:(D-1)
    Mp_cell{j} = Mp(:,1 +(j-1)*nu: j*nu); 
end

ku = cell(1,D-1);
for j=1:(D-1)
    ku{j} = K1*Mp_cell{j};
end


%% Petla symulujaca dzialanie cyfrowego algorytmu DMC w wersji MIMO
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
        dUp(1+(i-1)*nu: 1+(i-1)*nu + (nu-1)) = du1 - du2;
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
    second_part = 0;
    for j=1:(D-1)
        second_part = second_part + ku{j}*dUp(1+(j-1)*nu: (j-1)*nu + nu);  
    end
    inputs(k, :) = (inputs(k-1, :))' +  ke*((setpoints(k,:))' - (outputs(k,:))') - second_part; 
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

disp(strcat('E_sum=', num2str(sum(error_sum))));
disp(error_sum);

if SAVE == 1
    while(1)
        dir_name = input('Podaj nazwę: ', 's');
        dir_name = strcat(dir_name, '/');
        base_name = strcat('../data/project/zad4/dmc/', dir_name);
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
    dlmwrite(strcat(base_name, 'ERROR_SUM.csv'), sum(error_sum), '\t');
    dumpSimulation(base_name, nu, ny, outputs, inputs, setpoints, errors);
end