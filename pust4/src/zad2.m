close all
addpath ../

%% parametry skryptu
SAVE = 1;
SIM_LEN = 500;

%% parametry obiektu i symulacji
delay = 5;
SIM_LEN = SIM_LEN + delay;
M = 3;
N = 4;

UPPs = [0; 0; 0; 0];
YPPs = [0; 0; 0];

%% zlozona odpowiedz skokowa
s = cell(SIM_LEN, 1);
for i=1:SIM_LEN
    s{i} = zeros(M,N);
end

%% symulacja dla kazdego toru
for i=1:N
    inputs = ones(SIM_LEN, N);
    inputs(:, 1) = UPPs(1)*ones(SIM_LEN, 1);
    inputs(:, 2) = UPPs(2)*ones(SIM_LEN, 1);
    inputs(:, 3) = UPPs(3)*ones(SIM_LEN, 1);
    inputs(:, 4) = UPPs(4)*ones(SIM_LEN, 1);
    
    outputs = ones(SIM_LEN, M);
    outputs(:, 1) = YPPs(1)*ones(SIM_LEN, 1);
    outputs(:, 2) = YPPs(2)*ones(SIM_LEN, 1);
    outputs(:, 3) = YPPs(3)*ones(SIM_LEN, 1);
    
    inputs(:, i) = (UPPs(i) + 1)*ones(SIM_LEN, 1);
    inputs(1:delay, i) = 0;
    
    for k=delay:SIM_LEN
        [y1, y2, y3] = symulacja_obiektu1(inputs(k-1, 1), inputs(k-2, 1), inputs(k-3, 1), inputs(k-4, 1), ...
                                          inputs(k-1, 2), inputs(k-2, 2), inputs(k-3, 2), inputs(k-4, 2), ...
                                          inputs(k-1, 3), inputs(k-2, 3), inputs(k-3, 3), inputs(k-4, 3), ...
                                          inputs(k-1, 4), inputs(k-2, 4), inputs(k-3, 4), inputs(k-4, 4), ...
                                          outputs(k-1, 1), outputs(k-2, 1), outputs(k-3, 1), outputs(k-4, 1), ...
                                          outputs(k-1, 2), outputs(k-2, 2), outputs(k-3, 2), outputs(k-4, 2), ...
                                          outputs(k-1, 3), outputs(k-2, 3), outputs(k-3, 3), outputs(k-4, 3));
        outputs(k, 1) = y1;
        outputs(k, 2) = y2;
        outputs(k, 3) = y3;
        s{k-delay+1}(:, i) = [y1; y2; y3];
    end
        
    figure(i)
    hold on
    plot(0:SIM_LEN-delay, outputs(delay:end,1));
    plot(0:SIM_LEN-delay, outputs(delay:end,2));
    plot(0:SIM_LEN-delay, outputs(delay:end,3));
    hold off
    
    %% ewentualny zapis pojedynczej odpowiedzi do pliku
    if SAVE == 1
        base_name = strcat('../data/project/zad2/skok_wejscia_', num2str(i));
        for input_num=1:N
            file_name = strcat(base_name, '_przebieg_wejscia_', num2str(input_num), '.csv');
            to_save = [(0:SIM_LEN-delay)' inputs(delay:end, input_num)];
            dlmwrite(file_name, to_save, '\t');
        end
        for output_num=1:M
            file_name = strcat(base_name, 'przebieg_wyjscia_', num2str(output_num), '.csv');
            to_save = [(0:SIM_LEN-delay)' outputs(delay:end, output_num)];
            dlmwrite(file_name, to_save, '\t');
        end
    end
end

%% zapis zlozonej odpowiedzi skokowej do pliku jako cell array
if SAVE == 1
    save('../data/project/zad2/zlozona_odp_skokowa.mat', 's');
end