clear all
options = optimoptions('fmincon', 'Algorithm', 'sqp', 'Display', 'iter', 'MaxFunctionEvaluations', 600);
REGULATOR_NUM = 2;

Y_MIN = -0.31546;
Y_MAX = 11.839;
DY = Y_MAX - Y_MIN;

OFFSET = DY/(REGULATOR_NUM+1);

FUZZY_YPPs = zeros(REGULATOR_NUM,1);
FUZZY_UPPs = zeros(REGULATOR_NUM,1);

for i=1:REGULATOR_NUM
    FUZZY_YPPs(i) = Y_MIN + (i*OFFSET);
    FUZZY_UPPs(i) = fmincon(@(Upp)upp_target(Upp, FUZZY_YPPs(i)), 0, [], [], [], [], -1, 1, [], options);

end

%% ograniczenia
K_min = 0.01;
K_max = 10;
Ti_min = 1;
Ti_max = 20;
Td_min = 0;
Td_max = 10;

FUZZY_PID_PARAMETERS = zeros(REGULATOR_NUM, 5);

for i=1:REGULATOR_NUM

Ypp = FUZZY_YPPs(i);
Upp = FUZZY_UPPs(i);

base_values = [0.5 7.25 1.62];
options = optimoptions('fmincon', 'Algorithm', 'sqp', 'Display', 'iter');

parameters = fmincon(@(parameters)pid_target_fun(parameters, Upp, Ypp), base_values, [], [], [], [], [K_min Ti_min Td_min], [K_max Ti_max Td_max], [], options);

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
output = Ypp*ones(SIM_LEN,1);
input = Upp*ones(SIM_LEN,1);
error = zeros(SIM_LEN,1);


%% generacja trajektorii zadanej
stpt = [((Ypp+1)*ones(SIM_LEN/4,1))' ((Ypp)*ones(SIM_LEN/4,1))' ((Ypp-1)*ones(SIM_LEN/4,1))' ((Ypp)*ones(SIM_LEN/4,1))'];


%% symulacja obiektu
for k = 12:SIM_LEN
    output(k) = symulacja_obiektu1y(u(k-5), u(k-6), y(k-1), y(k-2));    % pomiar wyjscia
    error(k) = stpt(k) - output(k);   % obliczenie uchyby
    
    input(k) = r2 * error(k-2) + r1 * error(k-1) + r0 * error(k) + input(k-1);  % wyliczenie sterowania
    
    if input(k) >= Umax
        input(k) = Umax;
    elseif input(k) <= Umin
        input(k) = Umin;
    end   
end

figure(1)
hold on
plot(stpt);
plot(output);
hold off

figure(2)
plot(input)

FUZZY_PID_PARAMETERS(i,1:3) = parameters;
FUZZY_PID_PARAMETERS(i,4) = FUZZY_UPPs(i);
FUZZY_PID_PARAMETERS(i,5) = FUZZY_YPPs(i);
end