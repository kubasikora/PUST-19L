b1 = 0.003551;
b2 = 0.003395;
a1 = 0.01013;
a2 = -0.9899;
Td = 12;

Upp = 26;
Ypp = 34.5;
sim_len = 800;

Umax = 100;
Umin = 0;

input = Upp*ones(sim_len, 1);
output = Ypp*ones(sim_len, 1);
rescaled_input = zeros(sim_len, 1);
rescaled_output = zeros(sim_len, 1);
error = zeros(sim_len, 1);

K = 20;
Ti = 500;
Td = 0.01;
T = 1;

r0 = K*(1 + T/(2*Ti) + Td/T);
r1 = K*(T/(2*Ti) - (2*Td)/T - 1);
r2 = (K*Td)/T;

error_sum = 0;
for k = 15:sim_len     
    output(k) = symulacjaObiektuCH_G(input(k-13), input(k-14), output(k-1), output(k-2));    % pomiar wyjscia
    rescaled_output = output(k) - Ypp;  % skalowanie wyjscia   
    stpt = setpoint(k) - Ypp;   % przeskalowany setpoint
    error(k) = stpt - rescaled_output;   % obliczenie uchyby   
    
    error_sum = error_sum + error(k)^2;
    
    rescaled_input(k) = r2 * error(k-2) + r1 * error(k-1) + r0 * error(k) + rescaled_input(k-1);  % wyliczenie sterowania     
    input(k) = input(k) + rescaled_input(k);
    
    if input(k) >= Umax
        input(k) = Umax;
    elseif input(k) <= Umin
        input(k) = Umin;
    end 
end

hold on;
plot(output);
plot(setpoint);
figure 
plot(input);