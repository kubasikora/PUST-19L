function error = upp_target(Upp, Ypp)
    addpath ../
    
    SIM_LEN = 500;
    
    output = Ypp*ones(SIM_LEN,1);
    input = Upp*ones(SIM_LEN,1);  
    for k = 12:SIM_LEN
        output(k) = symulacja_obiektu1y(u(k-5), u(k-6), y(k-1), y(k-2));    % pomiar wyjscia
    end
    
    error = abs(Ypp - output(SIM_LEN));
end

