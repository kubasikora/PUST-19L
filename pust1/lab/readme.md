POMIARY DO WYKONANIA:

## PID
w kwestii K:
- K= 1 Ti = 9999999999999 Td = 0 %done
- K = 20 Ti = 9999999999999 Td = 0  %done
- K = 40 Ti = 9999999999999 Td = 0 %done 

w kwestii Ti:
- K = 20 Ti = 1000 Td = 0 %done 
- K = 20 Ti = 500 Td = 0 %done
- K = 20 Ti = 200 Td = 0 %done

w kwestii Td:
- K = 20 Ti = 200 Td = 10 %done
- K = 20 Ti = 200 Td = 1 % done 
- K = 20 Ti = 200 Td = 0.3 % done 

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
Dla N
- D = 500; N = 200; Nu = N; lambda = 100; % done
- D = 500; N = 140; Nu = N;  lambda = 100; % najlepszy 
- D = 500; N = 100; Nu = N;  lambda = 100;

Dla Nu
- D = 500; N = 140; Nu = 40; lambda = 100; % widać zmiane w stosunku do 140
- D = 500; N = 140; Nu = 10; lambda = 100; % jest spoko ale pierwszy garb jest troche przeregulowany 
- D = 500; N = 140; Nu = 1; lambda = 100; % mysle, ze najlepszy 

Dla lambda
- D = 500; N = 140;  Nu = 1;  lambda = 80; % najlepsze (zdecydowanie najlepsze dla 200 probek)
- D = 500; N = 140;  Nu = 1;  lambda = 50; % dochodzi do wartosci zadanej dopiero po 400 probkach
- D = 500; N = 140;  Nu = 1;  lambda = 130; % wzrasta przeregulowanie (dość mocno) nie musimy tego sprawdzać na labach, ale fajnie wiedziec co się dzieje dla większyc wartości 
