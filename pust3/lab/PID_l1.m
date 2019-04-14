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

stpt_value_1 = 34.93;
stpt_value_2 = 39.93;
stpt_value_3 = 49.93;
stpt_value_4 = 34.93;

setpoint = [stpt_value_1*ones(SIM_LEN/4, 1)' stpt_value_2*ones(SIM_LEN/4, 1)' stpt_value_3*ones(SIM_LEN/4, 1)' stpt_value_4*ones(SIM_LEN/4, 1)'];

input = Upp*ones(SIM_LEN, 1);
output = Ypp*ones(SIM_LEN, 1);

rescaled_input = zeros(SIM_LEN, 1);
error = zeros(SIM_LEN, 1);

%% init PID 
K = 20;
Ti = 200;
Td = 1;

r0 = K*(1+T/(2*Ti) + Td/T);
r1 = K*(T/(2*Ti) - (2*Td)/T - 1);
r2 = (K*Td)/T;

%% control loop
error_sum = 0;
for k=3:SIM_LEN
    %% read measurements from 1 to 7 
    measurements = readMeasurements(1:7);
    
    %% plot 
    y=[y measurements(1)];

    plot(y)
    drawnow
    
    %% processing of the measurements and new control values calculation
    act_output = measurements(1);
    rescaled_output = act_output - Ypp;
    stpt = setpoint(k) - Ypp;
    error(k) = stpt - rescaled_output;
    
    error_sum = error_sum + error(k)^2;
    rescaled_input(k) = r2 * error(k-2) + r1 * error(k-1) + r0 * error(k) + rescaled_input(k-1);  % wyliczenie sterowania 
    
    input(k) = input(k) + rescaled_input(k);
    if input(k) >= Umax
        input(k) = Umax;
    elseif input(k) <= Umin
        input(k) = Umin;
    end
    
    
    %% sending new values of control signals
    %sendControls([ 1, 2, 3, 4, 5, 6], ... send for these elements
    %    [ 50, 0, 0, 0, input(k), 0]);  % new corresponding control values
    sendNonlinearControls(input(k));
    disp([k setpoint(k) measurements(1) input(k)]); % process measurements
    
    %% synchronising with the control process
    waitForNewIteration(); % wait for new batch of measurements to be ready
end
