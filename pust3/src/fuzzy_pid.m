LOCAL_REGS = 2;
evalFuzzyMatrix = 0;

if evalFuzzyMatrix == 1
    fuzzyMatrix = fuzzyPIDParameters(LOCAL_REGS);
end

addpath ../
error_sum = 0;

%% parametry symulacji
Umin = -1;  
Umax = 1;
T = 0.5;
SIM_LEN = 3000;

Ypp = 0;
Upp = 0;

%% wektory i/o
output = Ypp*zeros(SIM_LEN,1);
input = Upp*zeros(SIM_LEN,1);
error = zeros(SIM_LEN,1);


%% generacja trajektorii zadanej
stpt = createSetpointTrajectory(SIM_LEN);

local_inputs = zeros(LOCAL_REGS,1);
memberships = zeros(LOCAL_REGS,1);
%% symulacja obiektu
for k = 12:SIM_LEN
    output(k) = symulacja_obiektu1y(input(k-10), input(k-11), output(k-1), output(k-2));    % pomiar wyjscia
    error(k) = stpt(k) - output(k);   % obliczenie uchyby
    
    for i=1:LOCAL_REGS
        parameters = fuzzyMatrix(i, 1:3);
        K = parameters(1);
        Ti = parameters(2);
        Td = parameters(3);
        r0 = K*(1 + T/(2*Ti) + Td/T);
        r1 = K*(T/(2*Ti) - (2*Td)/T - 1);
        r2 = (K*Td)/T;
        
        local_inputs(i) = r2 * error(k-2) + r1 * error(k-1) + r0 * error(k) + input(k-1);  % wyliczenie lokalnego sterowania
    end
    
    for i=1:LOCAL_REGS
        memberships(i) = trapezoid(local_inputs(i), fuzzyMatrix(i,5));
    end
    
    for i=1:LOCAL_REGS
        input(k) = input(k) + local_inputs(i)*memberships(i);
    end
    
    if sum(memberships) ~= 0
        input(k) = input(k)/sum(memberships);
    end
    
    if input(k) >= Umax
        input(k) = Umax;
    elseif input(k) <= Umin
        input(k) = Umin;
    end
    
    error_sum = error_sum + error(k)^2;
end

close all

figure(1)
hold on
plot(stpt)
plot(output)
legend('y^{zad}', 'y')
title('Wyjście procesu')
hold off

figure(2)
hold on
plot(input)
legend('u')
title('Przebieg sterowania')
hold off

figure(3)
hold on 
for i=1:LOCAL_REGS
    x = linspace(-2, 12);
    memb = zeros(length(x),1);
    for j=1:length(x)
        memb(j) = trapezoid(x(j), fuzzyMatrix(i,5));
    end
    plot(x, memb);
end
hold off

