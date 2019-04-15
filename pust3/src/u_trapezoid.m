function y = u_trapezoid(x, ypp)
    a = ypp - 1;
    b = ypp - 5;
    c = ypp + 1;
    d = ypp + 5;
    y = 0;
    if x <= a
        y = 0;
    end
    
    if x <= b && x > a
        y = (x-a)/(b-a);
    end
    
    if x > b && x <=c
        y = 1; 
    end
    
    if x > c && x <=d
        y = (d-x)/(d-c);
    end

    if x > d
        y = 0;
    end         
end

