function step = simulate_steps(Upp, Ypp)
    SIM_LEN = 500;
    du = 0.1;
    u = (du + Upp) * ones(SIM_LEN,1); % skok sterowania
    u(1:6) = Upp;
    y = Ypp * ones(SIM_LEN,1);
    for k = 7:SIM_LEN
       % y(k) = symulacja_obiektu1y(u(k-5), u(k-6), y(k-1), y(k-2));
       y(k) = 1.995*y(k-1)-0.9949*y(k-2)+0.002709*u(k-6);
    end
    
    
    step = y - Ypp;
    step = step / du;
    plot(step);
end