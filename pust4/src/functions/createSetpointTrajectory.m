function stpt = createSetpointTrajectory(sim_len)
    stpt1 = zeros(sim_len, 1);
    stpt2 = zeros(sim_len, 1);
    stpt3 = zeros(sim_len, 1);
    
    stpt1(floor(1*sim_len/18):ceil(3*sim_len/6), 1) = 1;
    stpt2(floor(1*sim_len/6):ceil(4*sim_len/6),1) = 0.75;
    stpt3(floor(2*sim_len/6):ceil(5*sim_len/6),1) = 1.25;
    
    stpt1(floor(3*sim_len/6):ceil(6*sim_len/6),1) = 0.4;
    stpt2(floor(4*sim_len/6):ceil(6*sim_len/6),1) = 1.5;
    stpt3(floor(5*sim_len/6):ceil(6*sim_len/6),1) = 0.8;
    
    stpt = [stpt1 stpt2 stpt3];
end

