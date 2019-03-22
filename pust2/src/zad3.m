addpath ../

Upp = 0;
Ypp = 0;
Dpp = 0;

dU = 0.2;
dD = 0.1;

sim_len = 300;
time = (1:sim_len)';

%% zebranie odpowiedzi skokowych dla dwoch torow
input = (Upp + dU) * ones(sim_len, 1);
output_u = Ypp * ones(sim_len,1);
disturbance = zeros(sim_len,1);

for k = 8:sim_len
    output_u(k) = symulacja_obiektu1y(input(k-6), input(k-7), disturbance(k-2), disturbance(k-3), output_u(k-1), output_u(k-2));
end

input = zeros(sim_len, 1);
output_d = Ypp * ones(sim_len,1);
disturbance = (Dpp + dD) * ones(sim_len, 1);

for k = 8:sim_len
    output_d(k) = symulacja_obiektu1y(input(k-6), input(k-7), disturbance(k-2), disturbance(k-3), output_d(k-1), output_d(k-2));
end
%% normalizacja odpowiedzi skokowej toru wejscie-wyjscie
output_u = output_u - Ypp;
output_u = output_u / dU;

%% normalizacja odpowiedzi skokowej toru zaklocenie-wyjscie
output_d = output_d - Ypp;
output_d = output_d / dD;

%% zapisanie znormalizowanych odpowiedzi skokowych
norm_resp_u = [time-1 output_u]; 
norm_resp_d = [time-1 output_d]; 

figure(1);
hold on
grid on
plot(time, output_u);
hold off

figure(2);
hold on
grid on
plot(time, output_d);
hold off

dlmwrite("../data/zad3/zad3_input_norm_resp.csv", norm_resp_u, '\t');
dlmwrite("../data/zad3/zad3_disturbance_norm_resp.csv", norm_resp_d, '\t');
