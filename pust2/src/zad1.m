%% tworzenie sygnalu sterujacego i wczytanie funkcji symulujacej obiekt
addpath ../
Upp = 0;
Zpp = 0;

sim_len = 200;
time = (1:sim_len)';

input = Upp*ones(sim_len, 1);
output = zeros(sim_len, 1);
disturbance = Zpp*ones(sim_len, 1);
%% symulacja obiektu
for k=8:sim_len
    output(k) = symulacja_obiektu1y(input(k-6),input(k-7),disturbance(k-2),disturbance(k-3),output(k-1),output(k-2));
end

figure(1)
plot(time, output);

figure(2)
plot(time, input);

%% zapis danych do pliku
input_ts = [time-1 input];
output_ts = [time-1 output];
disturbance_ts = [time-1 disturbance];
dlmwrite("../data/zad1/zad1_input.csv", input_ts, '\t');
dlmwrite("../data/zad1/zad1_output.csv", output_ts, '\t');
dlmwrite("../data/zad1/zad1_disturbance.csv", output_ts, '\t');