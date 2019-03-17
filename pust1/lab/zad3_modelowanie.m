% znalezienie modelu za pomocą fmincon

error_sum = 0;

load('norm_odp_skok.mat');

%% okreslenie ograniczen dla parametrow algorytmu
a1_min = -1000;
a1_max = 1000;
a2_min = -1000;
a2_max = 1000;
b1_min = -1000;
b1_max = 1000;
b2_min = -1000;
b2_max = 1000;
Td_min = 1;
Td_max = 20;

%% inicjalizacja punktu poczatkowego i opcji funkcji minimalizujacej
parameters0 = [1 1 1 1 8];
options = optimoptions('fmincon', 'Algorithm', 'sqp', 'Display', 'iter');
%[a1_min a2_min b1_min b2_min Td_min],[a1_max a2_max b1_max b2_max Td_max]
%% optymalizacja funkcja fmincon
parameters = fmincon(@model, parameters0,[],[],[],[],[a1_min a2_min b1_min b2_min Td_min],[a1_max a2_max b1_max b2_max Td_max], [], options);

%% wypisanie wartosci wspolczynnikow 
disp(['a1 = ' num2str(parameters(1)) ';']);
disp(['a2 = ' num2str(parameters(2)) ';']);
disp(['b1 = ' num2str(parameters(3)) ';']);
disp(['b2 = ' num2str(parameters(4)) ';']);
disp(['Td = ' num2str(parameters(5)) ';']);

a1 = parameters(1);
a2 = parameters(2);
b1 = parameters(3);
b2 = parameters(4);
Td = floor(parameters(5));


% wektor sygnalu sterujacego
input = ones(500, 1); 
model_output = zeros(500, 1);


%% Petla symulujaca dzialanie cyfrowego algorytmu PID
for k = (Td+2+1):500   
    model_output(k) =  b1*input(k - Td - 1) + b2* input(k - Td - 2) - a1*model_output(k-1) - a2*model_output(k-2); % pomiar wyjscia    
    error(k) = output(k) - model_output(k);
end

disp(sum(error.^2))
hold on
plot(model_output);
plot(output);

model_ts = [(1:length(model_output))' model_output];
dlmwrite('../data/lab/model_response_fmincon.csv', model_ts, '\t');

