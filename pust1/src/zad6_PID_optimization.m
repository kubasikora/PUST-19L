%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Projektowanie uk³adów sterowania
%          Projekt 1, zadanie 6
%
%   Program znajduj¹cy optymalne parametry 
%          cyfrowego regulatora PID
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

error_sum = 0;

%% okreslenie ograniczen dla parametrow algorytmu
K_min = 0.1;
K_max = 3;

Ti_min = 1;
Ti_max = 20;

Td_min = 0.001;
Td_max = 3;

%% inicjalizacja punktu poczatkowego i opcji funkcji minimalizujacej
parameters0 = [0.20296 4.9007 0.090366];
options = optimoptions('fmincon', 'Algorithm', 'sqp', 'Display', 'iter');

%% optymalizacja funkcja fmincon
parameters = fmincon(@zad6_PID_target_function, parameters0,[],[],[],[],[K_min Ti_min Td_min],[K_max Ti_max Td_max], [], options);

%% wypisanie wartosci wspolczynnikow 
disp(['K = ' num2str(parameters(1)) ';']);
disp(['Ti = ' num2str(parameters(2)) ';']);
disp(['Td = ' num2str(parameters(3)) ';']);





