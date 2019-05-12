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

