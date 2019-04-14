function ypp = get_ypp(upp)
    sim_len = 500;
    y = ones(sim_len,1);
    u = upp * ones(sim_len,1);
    
    for k = 7:sim_len
        y(k) = symulacja_obiektu1y(u(k-5), u(k-6), y(k-1), y(k-2));
    end

    ypp = y(end);
end