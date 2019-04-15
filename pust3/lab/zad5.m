%% init script
clear
addpath ../src
%addpath('F:\SerialCommunication'); % add a path to the functions
%initSerialControl COM21 % initialise com port

LOCAL_REGS = 3;
FUZZY_YPPS = [30 45 48];
Upp = 26;
Ypp = 34.5; % do ogarniecia
Umin = 0;
Umax = 100;
T = 1;
y = [];
SIM_LEN = 1000;
step_names = {'lab5_skokz35do40_norm.mat'  'lab5_skokz50do55_norm.mat' 'lab5_skokz65do70_norm.mat'};

sim_time = (1:SIM_LEN)';

stpt_value_1 = 34.93;
stpt_value_2 = 39.93;
stpt_value_3 = 49.93;
stpt_value_4 = 34.93;

stpt = [stpt_value_1*ones(SIM_LEN/4, 1)' stpt_value_2*ones(SIM_LEN/4, 1)' stpt_value_3*ones(SIM_LEN/4, 1)' stpt_value_4*ones(SIM_LEN/4, 1)'];

input = Upp*ones(SIM_LEN, 1);
output = Ypp*ones(SIM_LEN, 1);
rescaled_input = zeros(SIM_LEN, 1);
error = zeros(SIM_LEN, 1);

%% init DMC
D = 300;
N = 300;
Nu = 300;
lambda = [1; 0.1; 0.01];



for r=1:LOCAL_REGS
    mat_file = load(step_names{r});
    step = mat_file.y_norm;
    
    %% inicjalizacja macierzy algorytmu
    dU = zeros(Nu, 1);
    dUp = zeros(D-1, 1);
    M = zeros(N, Nu);
    Mp = zeros(N, D-1);
    K = zeros(Nu, N);

    %% wyliczenie macierzy 
    % macierz M
    for i = 1:Nu
        k = 1;
        for j = 1:N
            if j < i
                M(j, i) = 0;
            else
                M(j, i) = step(k);
                k = k + 1;
            end
        end
    end

    % macierz Mp
    for i = 1:N
        for j = 1:(D-1)
            k = i + j;
            if k > D
                Mp(i,j) = step(D) - step(j);
            else
                Mp(i,j) = step(k) - step(j);
            end
        end
    end

    %% macierz K
    K = inv((M' * M + lambda(r) * eye(Nu)))*M';

    %% control loop
    error_sum = 0;

    %% symulacja
    Ke(r, :) = sum(K(1,:));
    Ku(r, :) = K(1,:) * Mp;

end


local_inputs = zeros(LOCAL_REGS,1);
memberships = zeros(LOCAL_REGS,1);
for k=3:SIM_LEN
    %% read measurements from 1 to 7 
    measurements = readMeasurements(1:7);
    
    %% plot 
    y=[y measurements(1)];
    plot(y)
    drawnow
    
    %% processing of the measurements and new control values calculation
    act_output = measurements(1);
    
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
    
    output(k) = act_output;                                                                 % pomiar wyjscia
    rescaled_output = output(k) - Ypp;                                                      % skalowanie wyjscia   
    setpoint = stpt(k) - Ypp;                                                               % przeskalowany setpoint
    error(k) = setpoint - rescaled_output;                                                      % obliczenie uchyby   
    error_sum = error_sum + error(k)^2;   % wskaznik jakosci
    
    for r=1:LOCAL_REGS
        local_inputs(r) = Ke(r) * error(k) - Ku(r, :) * dUp;       
        memberships(r) = trapezoid(stpt(k), FUZZY_YPPS(r));
        rescaled_input(k) = rescaled_input(k) + local_inputs(r)*memberships(r);
    end
    
    if sum(memberships) ~= 0
        rescaled_input(k) = rescaled_input(k)/sum(memberships);
    end
    
    input(k) = input(k) + rescaled_input(k);  
   
    if input(k) >= Umax
        input(k) = Umax;
    elseif input(k) <= Umin
        input(k) = Umin;
    end 
     
    %% sending new values of control signals
    sendNonlinearControls(input(k));
    disp([k stpt(k) measurements(1) input(k) memberships(1) memberships(2) memberships(3)]); % process measurements
    
    %% synchronising with the control process
    waitForNewIteration(); % wait for new batch of measurements to be ready
end