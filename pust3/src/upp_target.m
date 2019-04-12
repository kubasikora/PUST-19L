function error = upp_target(Upp, Ypp)
    addpath ../
    
    SIM_LEN = 500;
    
    output = Ypp*ones(SIM_LEN,1);
    input = Upp*ones(SIM_LEN,1);  
    for k = 12:SIM_LEN
        output(k) = symulacja_obiektu1y(input(k-10), input(k-11), output(k-1), output(k-2));    % pomiar wyjscia
    end
    
    error = abs(Ypp - output(SIM_LEN));
end

