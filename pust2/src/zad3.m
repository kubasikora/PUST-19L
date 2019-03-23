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

%% zapis odpowiedzi skokowych
% dlmwrite("../data/zad3/zad3_input_norm_resp.csv", norm_resp_u, '\t');
% dlmwrite("../data/zad3/zad3_disturbance_norm_resp.csv", norm_resp_d, '\t');

%% przyciecie odpowiedzi skokowych na potrzeby algorytmu DMC
cut_time_u = 0;
cut_time_d = 0;

eps = 0.0001;

for i=2:sim_len
    if (output_u(i) - output_u(i-1) < eps && output_u(i) ~= 0)
        cut_time_u = i;
        break
    end
end

%% idk czy to potrzebne bo tam bylo ze Dz ma byc umiarkowanie maly
% nie no jednak potrzebne

for i=2:sim_len
    if (output_d(i) - output_d(i-1) < eps && output_d(i) ~= 0)
        cut_time_d = i;
        break
    end
end

%% zapis odpowiedzi skokowej z uwzglednieniem horyzontow D i Dz
cut_resp_u = output_u(1:cut_time_u);
cut_resp_d = output_d(1:cut_time_d);

figure(3)
plot(cut_resp_u);

figure(4)
plot(cut_resp_d);

cut_resp_u = [(1:cut_time_u)'-1 cut_resp_u];
cut_resp_d = [(1:cut_time_d)'-1 cut_resp_d];

%% zapis do plikow 
dlmwrite("../data/zad3/zad3_input_cut_response.csv", cut_resp_u, '\t');
dlmwrite("../data/zad3/zad3_disturbance_cut_response.csv", cut_resp_d, '\t');