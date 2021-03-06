function step = simulate_steps(Upp, Ypp)
    SIM_LEN = 500;
    du = 0.06;
    
    u = (du + Upp) * ones(SIM_LEN,1); % skok sterowania
    
    u(1:6) = Upp;
    
    y = Ypp * ones(SIM_LEN,1);
    
    for k = 7:SIM_LEN
       y(k) = symulacja_obiektu1y(u(k-5), u(k-6), y(k-1), y(k-2));
    end   
    step = y - Ypp;
    step = step / du;
    figure(10)
    plot(step);
end