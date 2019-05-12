addpath ../../data/lab/thermal_object/zad4/NOWE/

s = load('skok_u2_z_31_do_41.mat');

resp1 = zeros(150,1);
resp2 = zeros(150,1);

input = ones(80,1);

for i = 1:length(s.y1)
    if rem(i,4) == 0
        resp1(i/4) = s.y1(i);
        resp2(i/4) = s.y2(i);
    end
end

resp1 = resp1(1:80);
resp2 = resp2(1:80);

resp1 = resp1 - resp1(1);
resp1 = resp1/10;

resp2 = resp2 - resp2(1);
resp2 = resp2/10;

figure(1)
plot(resp1);

figure(2)
plot(resp2);