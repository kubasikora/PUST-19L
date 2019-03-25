addpath('F:\SerialCommunication'); % add a path to the functions
initSerialControl COM21 % initialise com port
Upp = 26;
figure;
y = [];
u_value = 0;
k=0;
disturbance_value = 0;
while(1)
    k=k+1;
    if(k > 30)
        disturbance_value = -20;
    end
    %% obtaining measurements
    measurements = readMeasurements(1:7); % read measurements from 1 to 7
    
    %% processing of the measurements and new control values calculation
    y=[y measurements(1)];
    %disp(measurements(1)); % process measurements
    plot(y)
    drawnow
    
    %% sending new values of control signals
    sendControls([ 1, 2, 3, 4, 5, 6], ... send for these elements
       [ 50, 0, 0, 0, Upp+u_value, 0]);  % new corresponding control values
    
    %sendControlsToG1AndDisturbance(Upp+u_value, disturbance_value);
    %disp([k Upp+u_value measurements(1) disturbance_value]);
    
    %% synchronising with the control process
    
    
    waitForNewIteration(); % wait for new batch of measurements to be ready
end