addpath ../../data/lab/thermal_object/zad4/NOWE/

s = load('skok_u1_z_26_do_36.mat');

resp = zeros(150,1);
input = ones(100,1);z da
for i = 1:length(s.y1)
    if rem(i,4) == 0
        resp(i/4) = s.y1(i);
    end
end

resp = resp(1:100);

resp = resp - resp(1);
resp = resp/10;

plot(resp);