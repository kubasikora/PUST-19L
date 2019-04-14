function y_zad = createSetpointTrajectory(len)
y_zad = zeros(len,1);
y_zad(1:ceil(len/6))= 0;
y_zad(floor(len/6): ceil(2*len/6)) = -0.3;
y_zad(floor(2*len/6): ceil(3*len/6)) = 5;
y_zad(floor(3*len/6): ceil(4*len/6)) = 11;
y_zad(floor(4*len/6): ceil(5*len/6)) = 7;
y_zad(floor(5*len/6): len) = 2;
end
