close all
clear all
addpath ../
addpath functions/

%% Parametry skryptu
SAVE = 0;
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

normalDMCTime = zeros(100,1);
classDMCTime = zeros(100,1);

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

Mp_cell = cell(1, D-1);
for j=1:(D-1)
    Mp_cell{j} = Mp(:,1 +(j-1)*nu: j*nu);
end

tic;
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
    Y_ZAD = duplicateVector(setpoints(k, :)', N*ny);
    Y = duplicateVector(outputs(k, :)', N*ny);
    dUK = K*(Y_ZAD - Y - Mp*dUp);
    
    inputs(k, :) = (inputs(k-1, :))' +  dUK(1:nu);
end
classDMCTime(timeTry) = toc;

error_sum = zeros(ny,1);
for i=1:ny
    error_sum(i) = sum(errors(:, i).^2);
end

classDMCOutputs = outputs;
classDMCInputs = inputs;
%%%%%%%%%%


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
end

normalDMCOutputs = outputs;
normalDMCInputs = inputs;

outputError = sum(sum(abs(normalDMCOutputs - classDMCOutputs)));
inputError = sum(sum(abs(normalDMCInputs - classDMCInputs)));

fprintf('Output error = %.16f\n', outputError);
fprintf('Input error = %.16f\n', inputError);

