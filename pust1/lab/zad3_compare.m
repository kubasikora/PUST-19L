% obliczanie błędu modelu uzyskanego za pomocą toolboxa System Identifiaction

load('norm_odp_skok.mat');

b1 = 0.003551;
b2 = 0.003395;
a1 = 0.01013;
a2 = -0.9899;
Td = 12;

model_output = zeros(500,1);    
error = zeros(500,1);
input = ones(500,1);

for k = (Td+2+1):500   
    model_output(k) =  b1*input(k - Td - 1) + b2* input(k - Td - 2) - a1*model_output(k-1) - a2*model_output(k-2); % pomiar wyjscia    
    error(k) = output(k) - model_output(k);
end

disp(sum(error.^2));