addpath ../

%% tworzenie sygnalu sterujacego i wczytanie funkcji symulujacej obiekt
addpath ../
Upp = 0;
Ypp = 0;

sim_len = 200;
time = (1:sim_len)';

input = Upp*ones(sim_len, 1);
output = zeros(sim_len, 1);
%% symulacja obiektu
for k=7:sim_len
    output(k) = symulacja_obiektu1y(input(k-5),input(k-6),output(k-1),output(k-2));
end

figure(1)
plot(time, output);

figure(2)
plot(time, input);

%% zapis danych do pliku
input_ts = [time-1 input];
output_ts = [time-1 output];
dlmwrite("../data/project/zad1/zad1_input.csv", input_ts, '\t');
dlmwrite("../data/project/zad1/zad1_output.csv", output_ts, '\t');