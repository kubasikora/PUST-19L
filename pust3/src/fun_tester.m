x = linspace(-1, 12, 1000);
y = zeros(1000, 1);

for i=1:1000
    y(i) = triangle(x(i), 5);
end

plot(x,y);