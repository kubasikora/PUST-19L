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
y = Ypp*zeros(SIM_LEN,1);
u = Upp*zeros(SIM_LEN,1);
error = zeros(SIM_LEN,1);


%% generacja trajektorii zadanej
stpt = [((Ypp)*ones(SIM_LEN/4,1))' ((Ypp+1)*ones(SIM_LEN/4,1))' ((Ypp)*ones(SIM_LEN/4,1))' ((Ypp-1)*ones(SIM_LEN/4,1))'];


%% symulacja obiektu
for k = 7:SIM_LEN
    y(k) = symulacja_obiektu1y(u(k-5), u(k-6), y(k-1), y(k-2));    % pomiar wyjscia
    error(k) = stpt(k) - y(k);   % obliczenie uchyby
    
    u(k) = r2 * error(k-2) + r1 * error(k-1) + r0 * error(k) + u(k-1);  % wyliczenie sterowania
    
    if u(k) >= Umax
        u(k) = Umax;
    elseif u(k) <= Umin
        u(k) = Umin;
    end
    
    error_sum = error_sum + error(k)^2;
end
end
