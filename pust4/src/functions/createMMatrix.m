function M = createMMatrix(N, Nu, s)
    [ny, nu] = size(s{1});
    M = zeros(ny*N, nu*Nu);
    for i = 1:nu:Nu*nu
        k = 1;
        for j = 1:ny:N*ny
            if j/ny < i/nu
                M(j:j+(ny-1), i:i+(nu-1)) = zeros(ny, nu);
            else
                M(j:j+(ny-1), i:i+(nu-1)) = s{k};
                k = k + 1;
            end
        end
    end    
end


