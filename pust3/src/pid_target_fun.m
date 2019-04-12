function error_sum = pid_target_fun(parameters, Upp, Ypp)
addpath ../
error_sum = 0;

%% parametry symulacji
Umin = -1;
Umax = 1;
T = 0.5;
SIM_LEN = 800;


%% parametry ciagle
K = parameters(1);
Ti = parameters(2);
Td = parameters(3);


%% parametry dyskretne
r0 = K*(1 + T/(2*Ti) + Td/T);
r1 = K*(T/(2*Ti) - (2*Td)/T - 1);
r2 = (K*Td)/T;


%% wektory i/o
output = Ypp*zeros(SIM_LEN,1);
input = Upp*zeros(SIM_LEN,1);
error = zeros(SIM_LEN,1);


%% generacja trajektorii zadanej
stpt = [((Ypp)*ones(SIM_LEN/4,1))' ((Ypp+1)*ones(SIM_LEN/4,1))' ((Ypp)*ones(SIM_LEN/4,1))' ((Ypp-1)*ones(SIM_LEN/4,1))'];


%% symulacja obiektu
for k = 12:SIM_LEN
    output(k) = symulacja_obiektu1y(input(k-10), input(k-11), output(k-1), output(k-2));    % pomiar wyjscia
    error(k) = stpt(k) - output(k);   % obliczenie uchyby
    
    input(k) = r2 * error(k-2) + r1 * error(k-1) + r0 * error(k) + input(k-1);  % wyliczenie sterowania
    
    if input(k) >= Umax
        input(k) = Umax;
    elseif input(k) <= Umin
        input(k) = Umin;
    end
    
    error_sum = error_sum + error(k)^2;
end
end
