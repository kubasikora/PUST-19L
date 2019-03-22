%% wczytanie funkcji symulujacej obiekt i generacja wektorow bazowych
addpath ../

STATIC_CHAR_DENSITY = 200;
SIM_LEN = 200;

inputs_u = (linspace(-1, 1, STATIC_CHAR_DENSITY))';
inputs_d = (linspace(-1, 1, STATIC_CHAR_DENSITY))';

saturated_outputs_u = zeros(STATIC_CHAR_DENSITY, 1);
saturated_outputs_d = zeros(STATIC_CHAR_DENSITY, 1);

%% symulacja procesu i zebranie ostatniej wartosci
for i=1:STATIC_CHAR_DENSITY
    
    sim_output = zeros(SIM_LEN,1); 
    sim_disturbance = zeros(SIM_LEN,1);
    sim_input = inputs_u(i)*ones(SIM_LEN,1);
    
    for k=8:SIM_LEN
        sim_output(k) = symulacja_obiektu1y(sim_input(k-6), sim_input(k-7),sim_disturbance(k-2), sim_disturbance(k-3), sim_output(k-1),sim_output(k-2));
    end
    saturated_outputs_u(i) = sim_output(SIM_LEN);
end

for i=1:STATIC_CHAR_DENSITY
    
    sim_output = zeros(SIM_LEN,1); 
    sim_input = zeros(SIM_LEN,1);
    sim_disturbance = inputs_d(i)*ones(SIM_LEN,1);
    
    
    for k=8:SIM_LEN
        sim_output(k) = symulacja_obiektu1y(sim_input(k-6), sim_input(k-7),sim_disturbance(k-2), sim_disturbance(k-3), sim_output(k-1),sim_output(k-2));
    end
    saturated_outputs_d(i) = sim_output(SIM_LEN);
end
%% zapisanie charakterystk statycznych
figure(1);
hold on
grid on
grid minor
plot(inputs_u, saturated_outputs_u);
hold off
static_char_u = [inputs_u saturated_outputs_u];

figure(2);
hold on
grid on
grid minor
plot(inputs_d, saturated_outputs_d);
hold off
static_char_d = [inputs_d saturated_outputs_d];

dlmwrite("../data/zad2/zad2_static_char_u.csv", static_char_u, '\t');
dlmwrite("../data/zad2/zad2_static_char_d.csv", static_char_d, '\t');