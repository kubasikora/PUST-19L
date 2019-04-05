addpath ../
SIM_LEN = 200;
Ypp = 0;
Upp = 0;
Tp = 0.5;
dU = [-1 -0.8 -0.6 -0.4 -0.2 0.2 0.4 0.6 0.8 1];
time = (1:SIM_LEN)';

for u_zad = dU
    u = (Upp + u_zad)*ones(SIM_LEN,1);
    y = Ypp*ones(SIM_LEN,1);
    for k = 7:SIM_LEN
       y(k) = symulacja_obiektu1y(u(k-5), u(k-6), y(k-1), y(k-2));
    end
    output_ts = [time-1 y];
    dlmwrite(strcat('../data/project/zad2/odp_skok_u=', num2str(u_zad), '.csv'), output_ts, '\t');
end
