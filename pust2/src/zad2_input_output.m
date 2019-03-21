%% wczytanie funkcji symulującej obiekt i generacja wektorów bazowych w punkcie pracy
addpath ../

sim_len = 200;
time = (1:sim_len)';

Upp = 0;
Ypp = 0;
Dpp = 0;

deltas = [0.1 0.2 0.35 0.5 -0.1 -0.2 -0.35 -0.5];

disturbance = Dpp*ones(sim_len,1);
base_input = Upp*ones(sim_len,1);
base_output = Ypp*ones(sim_len,1);

merged_outputs = zeros(length(deltas)+1, sim_len);
merged_outputs(1,:) = (time-1)';

%% przeprowadzenie symulacji dla roznych wartosci skoku i zapis danych do pliku
figure(1);
hold on;
grid on;
grid minor;
for i=1:length(deltas)
    sim_input = base_input + deltas(i);
    sim_output = base_output;
    for k=12:sim_len
        sim_output(k) = symulacja_obiektu1y(sim_input(k-6), sim_input(k-7),disturbance(k-2), disturbance(k-3), sim_output(k-1),sim_output(k-2));
    end
    plot(time, sim_output);
    input_ts = [time-1 sim_input];
    output_ts = [time-1 sim_output];
    dlmwrite("../data/zad2_input_input" + num2str(deltas(i)) + ".csv", input_ts, '\t');
    dlmwrite("../data/zad2_input_output" + num2str(deltas(i)) + ".csv", output_ts, '\t');
    merged_outputs(i+1,:) = sim_output';
end
hold off
%% zapis wszystkich wyjsc do zbiorczego rysunku
dlmwrite("../data/zad2_input_outputs_merged.csv", merged_outputs, '\t');