classdef DMC
    properties
        step;
        D; N; Nu; lambda;
        M; Mp; K;
        dU; 
    end
    
    methods
        %% konstruktor
        function obj = DMC(step, D, N, Nu, lambda)
            obj.step = step;
            
            obj.D = D;
            obj.N = N;
            obj.Nu = Nu;
            obj.lambda = lambda;
            
            obj.M = calculate_M(obj);
            obj.Mp = calculate_Mp(obj);
            obj.K = inv((obj.M' * obj.M + obj.lambda * eye(obj.Nu)))*obj.M';            
        end
        
        %% macierz M
        function M = calculate_M(obj)
            M = zeros(obj.N, obj.Nu);
            for i = 1:obj.Nu
                k = 1;
                for j = 1:obj.N
                    if j < i
                        M(j, i) = 0;
                    else
                        M(j, i) = obj.step(k);
                        k = k + 1;
                    end
                end
            end
        end
        
        %% macierz Mp
        function Mp = calculate_Mp(obj)
            Mp = zeros(obj.N, obj.D-1);
            for i = 1:obj.N
                for j = 1:(obj.D-1)
                    k = i + j;
                    if k > obj.D
                        Mp(i,j) = obj.step(obj.D) - obj.step(j);
                    else
                        Mp(i,j) = obj.step(k) - obj.step(j);
                    end
                end
            end            
        end
        
        %% obliczanie sterowania
        function input = calculate_input(obj, error, dUp)
            Ke = sum(obj.K(1,:));
            Ku = obj.K(1,:) * obj.Mp;  
            input = Ke * error + Ku * dUp;
        end        
    end
end