function s = createStepResponseMatrix(cell_s)
    len = length(cell_s);
    [M, N] = size(cell_s{1});
    s = zeros(M, len*N);
    for i=1:len
        s(:, 1 + (i-1)*N: (i-1)*N + N) = cell_s{i};
    end
end

