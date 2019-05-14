function E = pidOptimTargetFun(parameters, CONNECTION_MATRIX, T)
    N = size(CONNECTION_MATRIX, 1);
    M = size(CONNECTION_MATRIX, 2);
    SIM_LEN = 1000;
    UPPs = [0; 0; 0; 0];
    YPPs = [0; 0; 0];
    
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
    setpoints = createOptimSetpointTrajectory(SIM_LEN);

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
    
    E = sum(error_sum);
end