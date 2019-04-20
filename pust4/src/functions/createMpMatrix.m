function Mp = createMpMatrix(N, D, s)
    [ny, nu] = size(s{1});
    Mp = zeros(ny*N, nu*(D-1));
    for i = 1:N
        for j = 1:(D-1)
            k = i + j;
            if k > D
                Mp(1+(i-1)*ny: 1 +(i-1)*ny+(ny-1), 1+(j-1)*nu:1+(j-1)*nu+(nu-1)) = s{D} - s{j};
            else
                Mp(1+(i-1)*ny: 1 +(i-1)*ny+(ny-1), 1+(j-1)*nu:1+(j-1)*nu+(nu-1)) = s{k} - s{j};
            end
        end
    end
end

