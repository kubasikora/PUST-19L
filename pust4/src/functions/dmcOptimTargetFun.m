function E = dmcOptimTargetFun(parameters, D, N, Nu, M, Mp)
    SIM_LEN = 600;
    lambda = parameters(1:4);
    mi = parameters(5:7);
    
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
    setpoints = createOptimSetpointTrajectory(SIM_LEN);

    %% Generacja macierzy algorytmu DMC
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
    
    E = sum(error_sum);
end

