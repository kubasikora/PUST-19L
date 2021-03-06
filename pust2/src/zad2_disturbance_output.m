%% wczytanie funkcji symulującej obiekt i generacja wektorów bazowych w punkcie pracy
addpath ../

sim_len = 200;
time = (1:sim_len)';

Dpp = 0;
Ypp = 0;
Upp = 0;

deltas = [0.05 0.2 0.35 0.5 -0.05 -0.2 -0.35 -0.5];

input = Upp*ones(sim_len,1);
base_disturbance = Dpp*ones(sim_len,1);
base_output = Ypp*ones(sim_len,1);

merged_outputs = zeros(length(deltas)+1, sim_len);
merged_outputs(1,:) = (time-1)';

%% przeprowadzenie symulacji dla roznych wartosci skoku i zapis danych do pliku
figure(2);
hold on;
grid on;
grid minor;
for i=1:length(deltas)
    sim_disturbance = base_disturbance + deltas(i);
    sim_output = base_output;
    for k=8:sim_len
        sim_output(k) = symulacja_obiektu1y(input(k-6),input(k-7),sim_disturbance(k-2),sim_disturbance(k-3),sim_output(k-1),sim_output(k-2));
    end
    plot(time, sim_output);
    disturbance_ts = [time-1 sim_disturbance];
    output_ts = [time-1 sim_output];
    dlmwrite("../data/zad2/zad2_disturbance_disturbance" + num2str(deltas(i)) + ".csv", disturbance_ts, '\t');
    dlmwrite("../data/zad2/zad2_disturbance_output" + num2str(deltas(i)) + ".csv", output_ts, '\t');
    merged_outputs(i+1,:) = sim_output';
end
hold off
%% zapis wszystkich wyjsc do zbiorczego rysunku
dlmwrite("../data/zad2/zad2_disturbance_outputs_merged.csv", merged_outputs, '\t');