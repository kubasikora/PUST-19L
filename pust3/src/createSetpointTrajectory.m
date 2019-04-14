function y_zad = createSetpointTrajectory(len)
y_zad = zeros(len,1);
y_zad(1:len/6)= 0;
y_zad(len/6: 2*len/6) = -0.3;
y_zad(2*len/6: 3*len/6) = 5;
y_zad(3*len/6: 4*len/6) = 11;
y_zad(4*len/6: 5*len/6) = 7;
y_zad(5*len/6: len) = 2;
end
