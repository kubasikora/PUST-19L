POMIARY DO WYKONANIA:

## PID
w kwestii K:
- K = 20 Ti = 9999999999999 Td = 0
- K = 40 Ti = 9999999999999 Td = 0

w kwestii Ti:
- K = 50 Ti = 1000 Td = 0
- K = 50 Ti = 500 Td = 0
- K = 50 Ti = 200 Td = 0

w kwestii Td:
- K = 50 Ti = 500 Td = 5
- K = 50 Ti = 500 Td = 1
- K = 50 Ti = 500 Td = 0.3

## DMC LAB
1. 
D = 370;
N = 300;
Nu = 50;
lambda = 80;

2.
D = 500;
N = 250; 
Nu = 50; 
lambda = 180;

3. Bardzo podobne przebiegi do pkt 2.
D = 500;
N = 280; 
Nu = 50; 
lambda = 150;

## Nowe DMC
1. Dla N
D = 500;
N = 200; 
Nu = N; 
lambda = 100;

D = 500;
N = 140; % najlepszy
Nu = N; 
lambda = 100;

D = 500;
N = 100; 
Nu = N; 
lambda = 100;

2. Dla Nu
D = 500;
N = 140; 
Nu = 40; % widać zmiane w stosunku do 140
lambda = 100;

D = 500;
N = 140; 
Nu = 10; % jest spoko ale pierwszy garb jest troche przeregulowany 
lambda = 100;

D = 500;
N = 140; 
Nu = 1; % mysle, ze najlepszy 
lambda = 100;

3. Dla lambda
D = 500;
N = 140; 
Nu = 1; 
lambda = 80; % najlepsze (zdecydowanie najlepsze dla 200 probek)

D = 500;
N = 140; 
Nu = 1; 
lambda = 50; % dochodzi do wartosci zadanej dopiero po 400 probkach


D = 500;
N = 140; 
Nu = 1; 
lambda = 130; % wzrasta przeregulowanie (dość mocno) nie musimy tego sprawdzać na labach, ale fajnie wiedziec co się dzieje dla większyc wartości 
