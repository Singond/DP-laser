pkg load report;

saturation_overall;
X = saturation_separate;

gp = gnuplotter;
gp.load("../gnuplot/style.gp");
gp.load("../gnuplot/style-cairo.gp");
gp.xlabel('energie pulzu $\\enlaser\\,[\\si{\\micro\\joule}]$');
gp.ylabel('intenzita $\\lif\\,[\\si\\arbunit]$');
gp.exec("\n\
	set xrange [0:4.2] \n\
	set yrange [0:10.5] \n\
	set xtics 1 \n\
	unset key \n\
");
Escale = 1e6;
x = saturationt;
gp.plot(x.E * Escale, x.in, "w p ls 1 pt 13 ps 1");
[Lmin, Lmax] = bounds(x.E);
LL = linspace(0, Lmax);
gp.plot(LL * Escale, x.fite.f(LL), "w l ls 1 dt 1");
nonsat = x.fite.a * LL;

gp.export("results/saturation-overall.tex", "cairolatex", "size 10cm,8cm");
gp.export("results/saturation-lg.tex", "cairolatex", "size 10cm,8cm");  ## old
gp.clearplot;

gp.exec("\n\
	set lmargin at screen 0.23 \n\
	set rmargin at screen 0.95 \n\
	set tmargin at screen 0.95 \n\
	set bmargin at screen 0.23 \n\
	set xtics offset 0,0.3 \n\
	set xlabel offset 0,1 \n\
");
gp.plot(x.E * Escale, x.in, "w p ls 1 pt 13 ps 0.3");
gp.plot(LL * Escale, x.fite.f(LL), "w l ls 1");
gp.plot(LL * Escale, nonsat, "w l ls 1 dt 2");
gp.export("results/saturation-overall-small.tex",...
	"cairolatex", "size 5.4cm,4cm");
clear gp Emin Emax m p;
