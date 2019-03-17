%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Projektowanie uk�ad�w sterowania
%          Projekt 1, zadanie 6
%
%   Program znajduj�cy optymalne parametry 
%               regulatora DMC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

error_sum = 0;

%% okreslenie ograniczen dla parametrow algorytmu
N_min = 1;
N_max = 40;

Nu_min = 1;
Nu_max = 15;

lambda_min = 0.000001;
lambda_max = 10000;

%% inicjalizacja punktu poczatkowego i opcji funkcji minimalizujacej
parameters = [22 6 5];
options = optimoptions('fmincon', 'Algorithm', 'sqp', 'Display', 'iter');
options_ga = optimoptions('ga',  'Display', 'iter');

%% optymalizacja funkcja fmincon
% parameters = fmincon(@zad6_DMC_target_function, parameters0,[],[],[],[],[N_min Nu_min lambda_min],[N_max Nu_max lambda_max], [], options);
parameters = ga(@zad6_DMC_target_function, 3,[],[],[],[],[N_min Nu_min lambda_min],[N_max Nu_max lambda_max], [], options_ga);

%% wypisanie wartosci wspolczynnikow 
disp(['N = ' num2str(parameters(1)) ';']);
disp(['Nu = ' num2str(parameters(2)) ';']);
disp(['lambda = ' num2str(parameters(3)) ';']);