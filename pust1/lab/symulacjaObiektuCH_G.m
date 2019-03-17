function output = symulacjaObiektuCH_G(uk13, uk14, yk1, yk2)
    Ypp = 34.5;
    Upp = 26;
    b1 = 0.003551;
    b2 = 0.003395;
    a1 = 0.01013;
    a2 = -0.9899;
    %Td = 12;
    
    output = b1*(uk13-Upp) + b2*(uk14-Upp) - a1*(yk1-Ypp) - a2*(yk2-Ypp) + Ypp;
end

