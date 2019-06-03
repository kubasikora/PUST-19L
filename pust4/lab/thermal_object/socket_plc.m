%%Socket Communication demo script
delete(instrfindall)
pause(2);

close all;
clear all; 
  
t = tcpip('192.168.127.250', 4000, 'NetworkRole', 'client');

t.OutputBufferSize = 3000;
t.InputBufferSize = 3000;
 
fopen(t);
U_x = [];
U_y = [];
Y_x = [];
Y_y = [];
stpt1 = [];
stpt2 = [];

figure(1);
while (length(Y_x) < 1000)
    if (t.BytesAvailable ~= 0)
        temp = fscanf(t);
        disp(temp);
        eval(temp);
        U_x = [U_x; u_x];
        U_y = [U_y; u_y];
        Y_x = [Y_x; y_x];
        Y_y = [Y_y; y_y];
        stpt1 = [stpt1; STPT1];
        stpt2 = [stpt2; STPT2];
        
        subplot(4,1,1); plot(Y_x); title('Wyjœcie 1'); xlabel('iteracja');  
        subplot(4,1,2); plot(Y_y); title('Wyjœcie 2'); xlabel('iteracja'); 
        subplot(4,1,3); stairs(U_x); title('Sterowanie 1'); xlabel('iteracja');
        subplot(4,1,4); stairs(U_y); title('Sterowanie 2'); xlabel('iteracja');
        drawnow
    end
    pause(0.05);
end

fclose(t);
delete(t);
clear t;

