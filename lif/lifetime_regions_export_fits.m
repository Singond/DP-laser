pkg load report;

if (!exist("lifetime", "var"))
	lifetime_regions;
end
X = lifetime;

gp = gnuplotter;
gp.load("../gnuplot/style.gp");
gp.load("../gnuplot/style-cairo.gp");
gp.exec("set palette gray");
gp.title('Časový vývoj');
gp.xlabel('čas $\\tim\\,[\\si{\\nano\\second}]$');
gp.ylabel('intenzita $\\lif\\,[\\si\\arbunit]$');
gp.exec("\n\
	set xrange [4:16] \n\
	set yrange [0:100] \n\
	set key samplen 2 height 1 \n\
");
tscale = 1;
tt = linspace(min(X(2).t), max(X(2).t), 1000);
gp.plot(X(2).t * tscale, X(2).in_center, "w p ls 1 t 'oblast 1'");
gp.plot(tt * tscale, X(2).fit_center.fite.f(tt), "w l ls 1 dt 2 t ''");
gp.plot(X(2).t * tscale, X(2).in_edge1,  "w p ls 2 t 'oblast 2'");
gp.plot(tt * tscale, X(2).fit_edge1.fite.f(tt),  "w l ls 2 dt 3 t ''");
gp.plot(X(2).t * tscale, X(2).in_edge2,  "w p ls 3 t 'oblast 3'");
gp.plot(tt * tscale, X(2).fit_edge2.fite.f(tt),  "w l ls 3 dt 4 t ''");
gp.export("results/lifetime.tex", "cairolatex", "size 8cm,6cm");
gp.export("results/lifetime-lg.tex", "cairolatex", "size 10cm,8cm");

gp = gnuplotter;
gp.load("../gnuplot/style.gp");
gp.load("../gnuplot/style-cairo.gp");
gp.xlabel('čas $\\tim\\,[\\si{\\nano\\second}]$');
gp.ylabel('intenzita $\\lif\\,[\\si\\arbunit]$');
gp.exec("\n\
	set lmargin at screen 0.23 \n\
	set rmargin at screen 0.95 \n\
	set tmargin at screen 0.95 \n\
	set bmargin at screen 0.23 \n\
	set xrange [3.6:16.4] \n\
	set yrange [-8:100] \n\
	set xtics offset 0,0.3 \n\
	set xlabel offset 0,1 \n\
	unset key \n\
");
x = lifetime(2);
tt = linspace(min(x.t), max(x.t), 1000);
gp.plot(x.t * tscale, x.in_center, "w p ls 1 pt 13 ps 0.4");
gp.plot(tt * tscale, x.fit_center.fite.f(tt), "w l ls 1");
gp.export("results/lifetime-example-small.tex",...
	"cairolatex", "size 5.4cm,4cm");

clear gp;
