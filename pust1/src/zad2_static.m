%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Projektowanie układów sterowania
%          Projekt 1, zadanie 1
%
%   Wykreslenie charakterystyki statycznej
%   y(u) obiektu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% wczytanie funkcji symulującej obiekt i generacja wektorów bazowych
addpath ../
STATIC_CHAR_DENSITY = 100;
SIM_LEN = 200;
inputs = (linspace(0.3, 0.7, STATIC_CHAR_DENSITY))';
saturated_outputs = zeros(STATIC_CHAR_DENSITY, 1);

%% symulacja procesu i zebranie ostatniej wartości
for i=1:length(inputs)
    sim_input = inputs(i)*ones(SIM_LEN,1);
    sim_output = zeros(SIM_LEN,1);
    for k=12:SIM_LEN
        sim_output(k) = symulacja_obiektu1Y(sim_input(k-10), sim_input(k-11), sim_output(k-1), sim_output(k-2));
    end
    saturated_outputs(i) = sim_output(SIM_LEN);
end

%% zapisanie charakterystki statycznej
hold on
grid on
grid minor
plot(inputs, saturated_outputs);
static_char = [inputs saturated_outputs];
dlmwrite("../data/zad2_static_char.csv", static_char, '\t');