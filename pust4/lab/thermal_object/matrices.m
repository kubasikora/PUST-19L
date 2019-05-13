clear
addpath ../../src/functions/

D = 100;
N = D;
Nu = N;
lambda = [100 100];
mi = [1 1];

ny = 2;
nu = 2;

s = complex_step;

M = createMMatrix(N,Nu,s);
Mp = createMpMatrix(N,D,s);
Psi = createPsiMatrix(N,mi);
Lambda = createLambdaMatrix(Nu, lambda);
K = inv(M'*Psi*M + Lambda)*((M')*Psi);
ke = evalKe(K, N, nu, ny);
ku = K(1,:)*Mp;

clc
licznik = 0;
for i = 1:length(ku)
    if rem(i,2)==0
        str = ['tablica_MP[' num2str(1) '].wiersz[' num2str(licznik) '] = ' num2str(ku(i)) ';'];
        disp(str);
        licznik = licznik+1;
    else
        str = ['tablica_MP[' num2str(0) '].wiersz[' num2str(licznik) '] = ' num2str(ku(i)) ';'];
        disp(str);
    end
end      