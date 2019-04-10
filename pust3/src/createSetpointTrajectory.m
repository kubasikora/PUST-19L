function y_zad = createSetpointTrajectory(len)
y_zad = zeros(len,1);
y_zad(1:len/10)= 0;
y_zad(len/10: 2*len/10) = -4;
y_zad(2*len/10: 3*len/10) = -2;
y_zad(3*len/10: 4*len/10) = 5;
y_zad(4*len/10: 5*len/10) = 10;
y_zad(5*len/10: 6*len/10) = 3;
y_zad(6*len/10: 7*len/10) = -2;
y_zad(7*len/10: 8*len/10) = 6;
y_zad(8*len/10: 9*len/10) = 4;
y_zad(9*len/10: len) = 0;
end
