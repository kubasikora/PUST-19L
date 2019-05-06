%%Socket Communication demo script
delete(instrfindall)
pause(2);

close all;
clear all; 
  
t = tcpip('192.168.127.250', 4000, 'NetworkRole', 'client');

t.OutputBufferSize = 3000;
t.InputBufferSize = 3000;
 
fopen(t);
u1 = [];
y1 = [];
u2 = [];
y2 = [];
stpt1 = [];
stpt2 = [];

figure(1);
while (length(y1) < 1000)
    if (t.BytesAvailable ~= 0)
        temp = fscanf(t);
        disp(temp);
        eval(temp);
        u1 = [u1; U1/10; U1/10; U1/10; U1/10;];
        y1 = [y1; Y1/100; Y1/100; Y1/100; Y1/100];
        u2 = [u2; U2/10; U2/10; U2/10; U2/10;];
        y2 = [y2; Y2/100; Y2/100; Y2/100; Y2/100];
        stpt1 = [stpt1; STPT1];
        stpt2 = [stpt2; STPT2];
        
        subplot(4,1,1); plot(y1); title('Wyjœcie 1'); xlabel('iteracja'); 
        subplot(4,1,2); plot(y2); title('Wyjœcie 2'); xlabel('iteracja'); 
        
   
        subplot(4,1,3); stairs(u1); title('Sterowanie 1'); xlabel('iteracja');
        subplot(4,1,4); stairs(u2); title('Sterowanie 2'); xlabel('iteracja');
        drawnow
    end
    pause(0.05);
end

fclose(t);
delete(t);
clear t;

