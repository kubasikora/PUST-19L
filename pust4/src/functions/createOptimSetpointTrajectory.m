function stpt = createOptimSetpointTrajectory(sim_len)
    stpt1 = zeros(sim_len, 1);
    stpt2 = zeros(sim_len, 1);
    stpt3 = zeros(sim_len, 1);
    
    stpt1(floor(1*sim_len/18):end, 1) = 1;
    stpt2(floor(2*sim_len/6):end, 1) = 0.75;
    stpt3(floor(4*sim_len/6):end ,1) = 1.25;
    
    stpt = [stpt1 stpt2 stpt3];
end

