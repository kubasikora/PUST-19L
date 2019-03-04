%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Projektowanie układów sterowania
%          Projekt 1, zadanie 1
%
%   Zebranie kilku odpowiedzi skokowych 
%   obiektu                               
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% wczytanie funkcji symulującej obiekt i generacja wektorów bazowych w punkcie pracy
addpath ../
sim_len = 200;
time = (1:sim_len)';
Upp = 0.5;
Ypp = 4;
deltas = [0.05 0.1 0.15 0.2 -0.05 -0.1 -0.15 -0.2];
base_input = Upp*ones(200,1);
base_output = Ypp*ones(200,1);
merged_outputs = zeros(length(deltas)+1, sim_len);
merged_outputs(1,:) = time';

%% przeprowadzenie symulacji dla roznych wartosci skoku i zapis danych do pliku
hold on;
grid on;
grid minor;
for i=1:length(deltas)
    sim_input = base_input + deltas(i);
    sim_output = base_output;
    for k=12:sim_len
        sim_output(k) = symulacja_obiektu1Y(sim_input(k-10), sim_input(k-11), sim_output(k-1), sim_output(k-2));
    end
    plot(time, sim_output);
    input_ts = [time sim_input];
    output_ts = [time sim_output];
    dlmwrite("../data/zad2_input" + num2str(deltas(i)) + ".csv", input_ts, '\t');
    dlmwrite("../data/zad2_output" + num2str(deltas(i)) + ".csv", output_ts, '\t');
    merged_outputs(i+1,:) = sim_output';
end

%% zapis wszystkich wyjsc do zbiorczego rysunku
dlmwrite("../data/zad2_outputs_merged.csv", merged_outputs, '\t');