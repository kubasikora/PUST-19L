function dumpSimulation(base_name, N, M, outputs, inputs, setpoints, errors)
    SIM_LEN = length(inputs(:,1));
    for i=1:N
        to_save = [(1:SIM_LEN)' inputs(:, i)];
        dlmwrite(strcat(base_name, 'input_', num2str(i), '.csv'), to_save, '\t');
    end
    
    for i=1:M
        to_save = [(1:SIM_LEN)' outputs(:, i)];
        dlmwrite(strcat(base_name, 'output_', num2str(i), '.csv'), to_save, '\t');
    end
    
    for i=1:M
        to_save = [(1:SIM_LEN)' setpoints(:, i)];
        dlmwrite(strcat(base_name, 'stpt_', num2str(i), '.csv'), to_save, '\t');
    end
    
    for i=1:M
        to_save = [(1:SIM_LEN)' errors(:, i)];
        dlmwrite(strcat(base_name, 'error_', num2str(i), '.csv'), to_save, '\t');
    end
end

