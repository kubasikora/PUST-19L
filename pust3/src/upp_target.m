function error = upp_target(Upp, Ypp)
    addpath ../
    
    SIM_LEN = 500;
    
    y = Ypp*ones(SIM_LEN,1);
    u = Upp*ones(SIM_LEN,1);  
    for k = 7:SIM_LEN
        y(k) = symulacja_obiektu1y(u(k-5), u(k-6), y(k-1), y(k-2));    % pomiar wyjscia
    end
    
    error = abs(Ypp - y(SIM_LEN));
end

