function Y = duplicateVector(vector, size)
    vectorSize = length(vector);
    Y = zeros(size, 1);
    for i=1:vectorSize:size
        Y(i:i+vectorSize-1) = vector;
    end
end

