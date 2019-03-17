% funkcja modelu

function error_sum = model(parameters)

    load('norm_odp_skok.mat');

    %% inicjalizacja wskaznika jakosci oraz stalych w programi
    sim_len = 500;
    
    
    %% inicjalizacja potrzebnych wektorow sygnalow procesowych
    % wektor sygnalu sterujacego
    input = ones(sim_len, 1);

    % wektor wyjscia
    model_output = zeros(sim_len, 1);

    % wektor uchybu
    error = zeros(sim_len, 1);

    %% Definicja parametrow ciaglych regulatora PID przeslanych jako argument funkcji
    a1 = parameters(1);
    a2 = parameters(2);
    b1 = parameters(3);
    b2 = parameters(4);
    Td = floor(parameters(5));

    %% Petla symulujaca dzialanie cyfrowego algorytmu PID
    for k = (Td+2+1):sim_len    
        model_output(k) =  b1*input(k-Td-1) + b2*input(k-Td-2) - a1*model_output(k-1) - a2*model_output(k-2); % pomiar wyjscia
        error(k) = output(k) - model_output(k);   % obliczenie uchybu
    end

error_sum = sum(error.^2); % suma bedaca wskaznikiem jakosci regulacji
end