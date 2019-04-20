function psi = createPsiMatrix(N, mi)
    ny = length(mi);
    psi = zeros(ny*N, ny*N);
    for i=1:N
        for j=1:ny
            psi(1+(i-1)*ny + (j-1), 1+(i-1)*ny + (j-1)) = mi(j);
        end
    end
end

