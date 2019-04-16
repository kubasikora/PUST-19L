clear all
%% Dodanie sciezki ze skryptem symulujacym dzialanie obiektu
addpath ../

%% Definicja stalych
Upp = 0;
Ypp = 0;
Umin = -1;
Umax = 1;
T = 0.5;   
SIM_LEN = 3000;

REGULATOR_NUM = 6;

%% wyliczenie offsetu kolejnych punktow pracy
%U = linspace(-1,1,200);
%offset = floor(length(U) / (REGULATOR_NUM+1));

%% punkty pracy dla regulatorow 
%FUZZY_YPPs = zeros(REGULATOR_NUM,1);
%FUZZY_UPPs = zeros(REGULATOR_NUM,1);

%for i=1:REGULATOR_NUM    
%   FUZZY_UPPs(i) = U(i*offset);
%    FUZZY_YPPs(i) = get_ypp(FUZZY_UPPs(i));
%end

options = optimoptions('fmincon', 'Algorithm', 'sqp', 'Display', 'iter', 'MaxFunctionEvaluations', 600);
addpath ../ 
Y_MIN = -0.31546;
Y_MAX = 11.839;
DY = Y_MAX - Y_MIN;
 
OFFSET = DY/(REGULATOR_NUM+1);

FUZZY_YPPs = zeros(REGULATOR_NUM,1);
FUZZY_UPPs = zeros(REGULATOR_NUM,1);

for i=1:REGULATOR_NUM
    FUZZY_YPPs(i) = Y_MIN + (i*OFFSET);
    FUZZY_UPPs(i) = fmincon(@(Upp)upp_target(Upp, FUZZY_YPPs(i)), 0, [], [], [], [], -1, 1, [], options);

end


%% parametry regulatorow DMC
D = 500;
N = D;
Nu = N;
lambda = 10000*ones(REGULATOR_NUM, 1);

%% macierze regulatorow
dUp = zeros(D-1, 1);
M = zeros(N, Nu);
Mp = zeros(N, D-1);
K = zeros(Nu, N);
Ke = zeros(REGULATOR_NUM, 1);
Ku = zeros(REGULATOR_NUM, D-1);

%% elementy regulatorow
STEPS = zeros(D,REGULATOR_NUM);

for i = 1:REGULATOR_NUM
    M = zeros(N, Nu);
    Mp = zeros(N, D-1);

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
    Ku(i,:) = K(1,:) * Mp;
end    
    
%% inicjalizacja potrzebnych zmiennych
error_sum = 0;

% czas symulacji
sim_time = 1:SIM_LEN; % do plotowania
sim_time = sim_time';

% wartosc zadana
stpt = createSetpointTrajectory(SIM_LEN);

% wektor sygnalu sterujacego
input = Upp*ones(SIM_LEN, 1);

% wektor wyjscia
output = Ypp*ones(SIM_LEN, 1); 

% wektor uchybu
error = zeros(SIM_LEN, 1);

local_inputs = zeros(REGULATOR_NUM,SIM_LEN);
memberships = zeros(REGULATOR_NUM,SIM_LEN);

%% symulacja procesu regulacji
for k=7:SIM_LEN    
    % wektor dUp
    for i = 1:(D-1)
        if (k-i) <= 0
            du1 = 0;
        else
            du1 = input(k - i);
        end
        if (k-i-1) <= 0
            du2 = 0;
        else
            du2 = input(k - i - 1);
        end 
        dUp(i) = du1 - du2;
    end
    
    
    output(k) = symulacja_obiektu1y(input(k-5), input(k-6), output(k-1), output(k-2)); 
    error(k) = stpt(k) - output(k);   
    error_sum = error_sum + error(k)^2;
    
    for i=1:REGULATOR_NUM        
        local_inputs(i,k) = Ke(i) * error(k) - Ku(i, :) * dUp; 
        if local_inputs(i,k) >= Umax
            local_inputs(i,k) = Umax;
        elseif local_inputs(i,k) <= Umin
            local_inputs(i,k) = Umin;
        end
    end
    
    for i=1:REGULATOR_NUM      
        local_inputs(i,k) = Ke(i) * error(k) - Ku(i, :) * dUp; 
        if local_inputs(i,k) >= Umax
            local_inputs(i,k) = Umax;
        elseif local_inputs(i,k) <= Umin
            local_inputs(i,k) = Umin;
        end
    end
    
    for i=1:REGULATOR_NUM
        memberships(i, k) = trapezoid(stpt(k), FUZZY_YPPs(i));
    end
    
    input(k) = 0;
    for i=1:REGULATOR_NUM
        input(k) = input(k) + (local_inputs(i,k) * memberships(i,k));
        
    end
    
    if sum(memberships(:,k)) ~= 0
        input(k) = input(k)/sum(memberships(:,k));
    end
    
    input(k) = input(k) + input(k-1);
    
    if input(k) >= Umax
        input(k) = Umax;
    elseif input(k) <= Umin
        input(k) = Umin;
    end
end

close all

figure(1)
hold on
plot(stpt)
plot(output)
legend('y^{zad}', 'y')
title(['Wyjscie, E = ', num2str(error_sum)]);
hold off

figure(2)
hold on
plot(input)
legend('u')
title('Przebieg sterowania')
hold off

figure(3)
hold on 
for i=1:REGULATOR_NUM
    x = linspace(-1, 12);
    memb = zeros(length(x),1);
    for j=1:length(x)
        memb(j) = trapezoid(x(j), FUZZY_YPPs(i));
    end
    memb_ts = [x' memb];
%     dlmwrite(strcat('../data/project/zad5/membership_', membershipFunction, '_', num2str(LOCAL_REGS), '.csv'), memb_ts, '\t');
    plot(x, memb);
end
hold off

figure(4)
hold on
plot(memberships(1,:));
plot(memberships(2,:));
hold off

