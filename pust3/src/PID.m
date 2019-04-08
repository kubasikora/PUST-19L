classdef PID
    properties
        K;
        Ti;
        Td;
        r0;
        r1;
        r2;
        T;
    end
    
    methods
        function obj = PID(K, Ti, Td, T)    %,U_min,U_max)
            obj.K = K;
            obj.Ti = Ti;
            obj.Td = Td;
            
            obj.T = T;
            
            obj.r0 = obj.K * (1 + obj.T / (2 * obj.Ti) + obj.Td / obj.T);
            obj.r1 = obj.K * (obj.T / (2 * obj.Ti) - (2 * obj.Td)/obj.T - 1);
            obj.r2 = (obj.K * obj.Td) / obj.T;
        end
        
        function input = calculate_input(obj, error, prev_input)
            input = obj.r2 * error(1) + obj.r1 * error(2) + obj.r0 * error(3) + prev_input;
        end
    end

end