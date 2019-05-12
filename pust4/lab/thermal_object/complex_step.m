function s = complex_step()
    addpath ../../data/lab/thermal_object/zad4/normalizacja/
    step_y1_u1 = importdata('appr_norm_response_y1_u1.csv');
    step_y1_u1 = step_y1_u1(:,2); 

    step_y2_u1 = importdata('appr_norm_response_y2_u1.csv');
    step_y2_u1 = step_y2_u1(:,2);

    step_y1_u2 = importdata('appr_norm_response_y1_u2.csv');
    step_y1_u2 = step_y1_u2(:,2);

    step_y2_u2 = importdata('appr_norm_response_y2_u2.csv');
    step_y2_u2 = step_y2_u2(:,2);

    SIM_LEN = 100;
    M = 2;
    N = 2;

    s = cell(SIM_LEN, 1);
    for i=1:SIM_LEN
        s{i} = zeros(M,N);
    end

    for i = 1:M
        for j = 1:SIM_LEN
            if i == 1
                y1 = step_y1_u1(j);
                y2 = step_y2_u1(j);
            else
                y1 = step_y1_u2(j);
                y2 = step_y2_u2(j);
            end
            s{j}(:,i) = [y1; y2];
        end
    end
end


