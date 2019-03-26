clear all
addpath ../

MESH = 20;
SIM_LEN = 300;

u = (linspace(-1,1, MESH))';
z = (linspace(-1,1, MESH))';

u_save = zeros(MESH*MESH, 1);
y_save = zeros(MESH*MESH, 1);
z_save = zeros(MESH*MESH, 1);
counter = 0;

for i=1:MESH
   for j=1:MESH
       output = zeros(SIM_LEN);
       sim_u = u(i)*ones(SIM_LEN);
       sim_z = z(j)*zeros(SIM_LEN);
       
       for k = 8:SIM_LEN
             output(k) = symulacja_obiektu1y(sim_u(k-6), sim_u(k-7), sim_z(k-2), sim_z(k-3), output(k-1), output(k-2));
       end
       counter = counter +1;
       u_save(counter) = u(i);
       z_save(counter) = z(j);
       y_save(counter) = output(SIM_LEN);
   end
end

to_save = [u_save z_save y_save];

dlmwrite('../data/zad2/mesh.csv', to_save, '\t');