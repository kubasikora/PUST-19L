 clear all
 close all
 
 Z = linspace(-1,1,200);
 U = linspace(-1,1,200);
 output = zeros(300,1);
 Y = zeros(200,200);
 Y_coordinates = zeros(200,600);
 
 %% przygotowanie wspolrzednych do macierzy Y
%  i = 0;
%  for k = 1:200
%  Y_coordinates(:,k + 2*i) = U;
%  i = i+1;
%  end
%  i = 0;
%  for k=2:201
%  Y_coordinates(:,k+2*i) = Z(k-1);
%  i = i+1;
%  end

 for i = 1:length(U)
     sim_u = U(i)*ones(300,1);     
     p = 1;
     for j = 1:length(Z)
         sim_d = Z(j)*ones(300,1);
         output = zeros(300,1);
         for k = 8:300
             output(k) = symulacja_obiektu1y(sim_u(k-6), sim_u(k-7), sim_d(k-2), sim_d(k-3), output(k-1), output(k-2));
         end
         Y(i,j) = output(k);
         Y_coordinates(i,j+2*p) = output(k);
         p = p+1;
     end     
 end
 figure(3);
 surf(U,Z,Y);
 
 %% zapis do plikow
 dlmwrite('../data/zad2/zad2_vector_U.csv', U);
 dlmwrite('../data/zad2/zad2_vector_Z.csv', Z);
 dlmwrite('../data/zad2/zad2_surface_Y.csv', Y, '\t');
%  dlmwrite('../data/zad2/zad2_surface_Y_coordinates.csv', Y_coordinates, '\t');