%% init script
clear
addpath('F:\SerialCommunication'); % add a path to the functions
initSerialControl COM21 % initialise com port

Upp = 26;
Ypp = 34.5; % do ogarniecia
Umin = 0;
Umax = 100;
T = 1;
y=[];

SIM_LEN = 800;
sim_time = (1:SIM_LEN)';

stpt_value_1 = 40;
stpt_value_2 = 30;
setpoint = [stpt_value_1*ones(SIM_LEN/2, 1)' stpt_value_2*ones(SIM_LEN/2, 1)'];

input = Upp*ones(SIM_LEN, 1);
output = Ypp*ones(SIM_LEN, 1);

rescaled_input = zeros(SIM_LEN, 1);
error = zeros(SIM_LEN, 1);

%% init DMC
N = 40;
Nu = 5;
lambda = 1;


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
K = inv((M' * M + lambda * eye(Nu)))*M';

%% control loop
error_sum = 0;
for k=3:SIM_LEN
    %% read measurements from 1 to 7 
    measurements = readMeasurements(1:7);
    
    %% plot 
    y=[y measurements(1)];
    disp([measurements(1) input(k-1)]); % process measurements
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
    stpt = setpoint(k) - Ypp;                                                               % przeskalowany setpoint
    error(k) = stpt - rescaled_output;                                                      % obliczenie uchyby   
    
    error_sum = error_sum + error(k)^2;                                                     % wskaznik jakosci
    
    rescaled_input(k) = Ke * error(k) - Ku * dUp;
    rescaled_input(k) = rescaled_input(k-1) + rescaled_input(k);
    
    % ograniczenia  
    if rescaled_input(k) - rescaled_input(k-1) >= dUmax
        rescaled_input(k) = dUmax + rescaled_input(k-1);
    elseif rescaled_input(k) - rescaled_input(k-1) <= -dUmax
        rescaled_input(k) = rescaled_input(k-1) - dUmax;
    end   
    
    input(k) = input(k) + rescaled_input(k);  
    
    if input(k) >= Umax
        input(k) = Umax;
    elseif input(k) <= Umin
        input(k) = Umin;
    end 
     
    %% sending new values of control signals
    sendControls([ 1, 2, 3, 4, 5, 6], ... send for these elements
        [ 50, 0, 0, 0, input(k), 0]);  % new corresponding control values
    
    %% synchronising with the control process
    waitForNewIteration(); % wait for new batch of measurements to be ready
end
