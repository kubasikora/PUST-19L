function ke = evalKe(K, N, nu, ny)
    ke = zeros(nu, ny);
    first_row = K(1:nu,:);
    for i=1:N
        for j=1:ny
            for k=1:nu
                ke(k, j) = ke(k, j) + first_row(k, 1+(i-1)*ny + j - 1);
            end
        end
    end
end

