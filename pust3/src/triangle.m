function y = triangle(x, ypp)
    a = ypp - 4.5;
    b = ypp + 4.5;
    
    if x <= a
        y = 0;
    end
    
    if x > a && x <= ypp
       y = (x-a)/(ypp-a);
    end
    
    if x > ypp && x <= b
        y = (b-x)/(b-ypp);
    end
    
    if x > b
        y = 0;
    end
end

