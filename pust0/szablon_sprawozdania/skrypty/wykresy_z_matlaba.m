x = 0:.001:pi;
y = sin(2*x.^4);

plot(x,y);
xlim([min(x) max(x)]);
xlabel('o� X');
ylabel('o� Y');
matlab2tikz('wykres_tex.tex','showInfo', false);