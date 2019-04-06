addpath ../
SIM_LEN = 200;
Ypp = 0;
Upp = 0;
Tp = 0.5;
dU = [-1 -0.8 -0.6 -0.4 -0.2 0.2 0.4 0.6 0.8 1];
time = (1:SIM_LEN)';

yS = zeros(length(dU),1);
i = 0;
for u_zad = dU
    u = (Upp + u_zad)*ones(SIM_LEN,1);
    y = Ypp*ones(SIM_LEN,1);
    for k = 7:SIM_LEN
       y(k) = symulacja_obiektu1y(u(k-5), u(k-6), y(k-1), y(k-2));
    end
    output_ts = [time-1 y];
    output_norm_ts = [time-1 (y-Ypp)./u_zad];
    dlmwrite(strcat('../data/project/zad2/odp_skok_u=', num2str(u_zad), '.csv'), output_ts, '\t');
    dlmwrite(strcat('../data/project/zad2/odp_skok_norm_u=', num2str(u_zad), '.csv'), output_norm_ts, '\t');
    i = i +1;
    yS(i) = y(SIM_LEN);
end

char_stat_short = [dU' yS];
dlmwrite('../data/project/zad2/char_stat_short.csv', char_stat_short, '\t');

%% szersza charakterystyka statyczna

STAT_POINTS = 200;
y_stat = zeros(STAT_POINTS,1);
u_stat = linspace(-1,1,STAT_POINTS);
i = 0;
for u_zad= u_stat
    u = (Upp + u_zad)*ones(SIM_LEN,1);
    y = Ypp*ones(SIM_LEN,1);
    for k = 7:SIM_LEN
       y(k) = symulacja_obiektu1y(u(k-5), u(k-6), y(k-1), y(k-2));
    end
    i = i + 1;
    y_stat(i) = y(SIM_LEN);
end

char_stat_long = [u_stat' y_stat];
dlmwrite('../data/project/zad2/char_stat_long.csv', char_stat_long, '\t');