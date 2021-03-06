%%%%%%%%%% REGULATOR ROZMYTY PID
LOCAL_REGS = 3;

%%%%%% postac macierzy Kp Ti Td Upp Ypp
fuzzyMatrix = [18 300 1 30 36.87;
               19 250 1 50 45.18;
               20 200 1 70 49.31];
           
error_sum = 0;

%% parametry symulacji
addpath('F:\SerialCommunication'); % add a path to the functions
initSerialControl COM21 % initialise com port

Umin = 0;  
Umax = 100;
T = 1;
SIM_LEN = 1000;

Ypp = 34.93;
Upp = 26;
y = [];

%% wektory i/o
output = Ypp*zeros(SIM_LEN,1);
input = Upp*zeros(SIM_LEN,1);
error = zeros(SIM_LEN,1);

%% generacja trajektorii zadanej
sim_time = (1:SIM_LEN)';

stpt_value_1 = 34.93;
stpt_value_2 = 39.93;
stpt_value_3 = 49.93;
stpt_value_4 = 34.93;

stpt = [stpt_value_1*ones(SIM_LEN/4, 1)' stpt_value_2*ones(SIM_LEN/4, 1)' stpt_value_3*ones(SIM_LEN/4, 1)' stpt_value_4*ones(SIM_LEN/4, 1)'];

local_inputs = zeros(LOCAL_REGS,1);
memberships = zeros(LOCAL_REGS,1);

%% symulacja obiektu
for k = 12:SIM_LEN
    measurements = readMeasurements(1:7);
    
    y=[y measurements(1)];
    plot(y)
    drawnow
    
    output(k) = measurements(1);
    error(k) = stpt(k) - output(k);   % obliczenie uchyby
    
    for i=1:LOCAL_REGS
        parameters = fuzzyMatrix(i, 1:3);
        K = parameters(1);
        Ti = parameters(2);
        Td = parameters(3);
        r0 = K*(1 + T/(2*Ti) + Td/T);
        r1 = K*(T/(2*Ti) - (2*Td)/T - 1);
        r2 = (K*Td)/T;
        
        local_inputs(i) = r2 * error(k-2) + r1 * error(k-1) + r0 * error(k) + input(k-1);  % wyliczenie lokalnego sterowania
    end
    
    for i=1:LOCAL_REGS
        memberships(i) = trapezoid(stpt(k), fuzzyMatrix(i,5));
    end
    
    for i=1:LOCAL_REGS
        input(k) = input(k) + local_inputs(i)*memberships(i);
    end
    
    if sum(memberships) ~= 0
        input(k) = input(k)/sum(memberships);
    end
    
    if input(k) >= Umax
        input(k) = Umax;
    elseif input(k) <= Umin
        input(k) = Umin;
    end
    
    error_sum = error_sum + error(k)^2;
    sendNonlinearControls(input(k));
    disp([k stpt(k) measurements(1) input(k) memberships(1) memberships(2) memberships(3)]); % process measurements
    
    %% synchronising with the control process
    waitForNewIteration(); % wait for new batch of measurements to be ready

end