function Lambda = createLambdaMatrix(Nu, lambda)
    nu = length(lambda);
    Lambda = zeros(nu*Nu, nu*Nu);
    for i=1:Nu
        for j=1:nu
            Lambda(1+(i-1)*nu + (j-1), 1+(i-1)*nu + (j-1)) = lambda(j);
        end
    end
end


