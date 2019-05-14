function ke = evalKe(K, N, nu, ny)
    ke = zeros(nu, ny);
    first_row = K(1:nu,:);
    K_cell = cell(1,N);
    for i=1:N
        K_cell{i} = first_row(:, 1+(i-1)*ny : (i-1)*ny + ny);
    end
    
    for i=1:N
        ke = ke + K_cell{i};
    end
end

