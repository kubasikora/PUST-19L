%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Projektowanie układów sterowania
%          Projekt 1, zadanie 1
%
%   Weryfikacja poprawności wartości
%   sygnałów Upp i Ypp                                      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% tworzenie sygnalu sterujacego i wczytanie funkcji symulującej obiekt
addpath ../
Upp = 0.5;
sim_len = 200;
time = (1:sim_len)';
input = Upp*ones(sim_len, 1);
output = zeros(sim_len, 1);

%% symulacja obiektu
for k=12:sim_len
    output(k) = symulacja_obiektu1Y(input(k-10), input(k-11), output(k-1), output(k-2));
end

plot(time, output, time, input);

%% zapis danych do pliku
input_ts = [time-1 input];
output_ts = [time-1 output];
dlmwrite("../data/zad1_input.csv", input_ts, '\t');
dlmwrite("../data/zad1_output.csv", output_ts, '\t');