clear all
%% Dodanie sciezki ze skryptem symulujacym dzialanie obiektu
addpath ../

%% Definicja stalych
Upp = 0;
Ypp = 0;
Umin = -1;
Umax = 1;
T = 0.5;   
SIM_LEN = 1000;

REGULATOR_NUM = 3;

%% wyliczenie offsetu kolejnych punktow pracy
Y_MIN = -0.31546;
Y_MAX = 11.839;
DY = Y_MAX - Y_MIN;
OFFSET = DY/(REGULATOR_NUM+1);

%% punkty pracy dla regulatorow 
FUZZY_YPPs = zeros(REGULATOR_NUM,1);
FUZZY_UPPs = zeros(REGULATOR_NUM,1);
options = optimoptions('fmincon', 'Algorithm', 'sqp', 'Display', 'iter', 'MaxFunctionEvaluations', 600);
for i=1:REGULATOR_NUM
    FUZZY_YPPs(i) = Y_MIN + (i*OFFSET);
    FUZZY_UPPs(i) = fmincon(@(Upp)upp_target(Upp, FUZZY_YPPs(i)), 0, [], [], [], [], -1, 1, [], options);
end

%% parametry regulatorow DMC
D = 150;
N = D;
Nu = N;
lambda = ones(REGULATOR_NUM, 1);

%% macierze regulatorow
dUp = zeros(D-1, 1);
M = zeros(N, Nu);
Mp = zeros(N, D-1);
K = zeros(Nu, N);
Ke = zeros(REGULATOR_NUM, 1);
Ku = zeros(D-1, REGULATOR_NUM);

%% elementy regulatorow
STEPS = zeros(D,REGULATOR_NUM);
for i = 1:REGULATOR_NUM
    M = zeros(N, Nu);
    Mp = zeros(N, D-1);
    K = zeros(Nu, N);

%% symulacja obiektu w celu otrzymania odp skokowej dla danego pkt pracy    
    step = simulate_steps(FUZZY_UPPs(i), FUZZY_YPPs(i));
    STEPS(:,i) = step(1:D);
    
%% wyliczenie macierzy 
    % macierz M
    for p = 1:Nu
        k = 1;
        for q = 1:N
            if q < p
                M(q, p) = 0;
            else
                M(q, p) = step(k);
                k = k + 1;
            end
        end
    end

    % macierz Mp
    for p = 1:N
        for q = 1:(D-1)
            k = p + q;
            if k > D
                Mp(p,q) = step(D) - step(q);
            else
                Mp(p,q) = step(k) - step(q);
            end
        end
    end

    % macierz K
    K = inv((M' * M + lambda(i) * eye(Nu)))*M';
    Ke(i) = sum(K(1,:));
    Ku(:,i) = K(1,:) * Mp;
end    
    
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


%% symulacja procesu regulacji
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
    %output(k) = symulacja_obiektu1y(input(k-5), input(k-6), output(k-1), output(k-2)); 
    output(k) = 1.995*output(k-1)-0.9949*output(k-2)+0.002709*input(k-3);
    rescaled_output = output(k) - Ypp;                                                     
    stpt = setpoint(k) - Ypp;                                                               
    error(k) = stpt - rescaled_output;   
    error_sum = error_sum + error(k)^2; 
    
end