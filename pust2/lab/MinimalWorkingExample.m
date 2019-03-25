function MinimalWorkingExample(u_value)
    addpath('F:\SerialCommunication'); % add a path to the functions
    initSerialControl COM21 % initialise com port
    Upp = 26;
    figure;
    global y;
    
    while(1)
        %% obtaining measurements
        measurements = readMeasurements(1:7); % read measurements from 1 to 7
        
        %% processing of the measurements and new control values calculation
        y=[y measurements(1)];
        disp(measurements(1)); % process measurements
        plot(y)
        drawnow
        
        %% sending new values of control signals
        sendControls([ 1, 2, 3, 4, 5, 6], ... send for these elements
                     [ 50, 0, 0, 0, Upp, 0]);  % new corresponding control values
        
        %% synchronising with the control process
        
        
        waitForNewIteration(); % wait for new batch of measurements to be ready
    end
end