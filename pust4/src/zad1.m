clear all
addpath ../

Upp1 = 0;
Upp2 = 0;
Upp3 = 0;
Upp4 = 0;

Ypp1 = 0;
Ypp2 = 0;
Ypp3 = 0;

[y1, y2, y3] = symulacja_obiektu1(Upp1, Upp1, Upp1, Upp1, ...
                                  Upp2, Upp2, Upp2, Upp2, ...
                                  Upp3, Upp3, Upp3, Upp3, ...
                                  Upp4, Upp4, Upp4, Upp4, ...
                                  Ypp1, Ypp1, Ypp1, Ypp1, ...
                                  Ypp2, Ypp2, Ypp2, Ypp2, ...
                                  Ypp3, Ypp3, Ypp3, Ypp3);
                            
assert(y1 == Ypp1);
assert(y2 == Ypp2);
assert(y3 == Ypp3);

