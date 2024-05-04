pkg load report;
pkg load singon-plasma;

lifetime_load;

x = lifetime(1);
points = [350];

##
## Fitted parameters
##
disp("Exporting results/lifetime-x-params.tex...");
gp = gnuplotter;
gp.load("../gnuplot/style.gp");
gp.load("../gnuplot/style-cairo.gp");
gp.xlabel('poloha $\\xpos\\,[\\si\\pixel]$');
gp.ylabel('doba života $\\tau\\,[\\si{\\nano\\second}]$');
gp.exec("\n\
	set key tmargin right columns 4 samplen 2 width 3 \n\
");
for x = lifetime
	gp.plot(x.xpos, x.taux, sprintf(
		"w l t '$\\SI{%.0f}{\\pascal}$'", x.p1));
end
k = 1;
for xp = points
	gp.exec("set arrow from first %g, graph 0.05 to first %g, graph 0.95 ls %d lc 'black' dt 2 nohead",
		xp, xp, k);
	k++;
end
gp.export("results/lifetime-x-params.tex",...
	"cairolatex", "pdf colourtext size 12.5cm,11cm");

##
## Fits
##
disp("Exporting results/lifetime-x-fits.tex...");
gp = gnuplotter;
gp.load("../gnuplot/style.gp");
gp.load("../gnuplot/style-cairo.gp");
gp.xlabel('čas $\\tim\\,[\\si{\\nano\\second}]$');
gp.ylabel('intenzita fluorescence $\\lif\\,[\\si\\arbunit]$');
gp.exec("\n\
	set xrange [68:142] \n\
	set yrange [-100:2600] \n\
	@padding \n\
	set key top right samplen 2 \n\
");
k = 1;
for x = lifetime(1:2:8)
	for xp = points
		xi = interp1(x.xpos, 1:length(x.xpos), xp, "nearest");
		tmin = 70;
		tmax = 140;
		tt = linspace(85, 140);
		m = tmin <= x.t & x.t <= tmax;
		gp.plot(x.t(m), squeeze(x.inx(1,xi,m)), sprintf(...
			"w p ls %d t'$\\pres=\\SI{%.0f}{\\pascal}, \\lifetime=\\SI{%.2f}{\\nano\\second}$'",...
			k, x.p1, x.taux(xi)));
		gp.plot(tt, x.fitsx(xi).fite.f(tt),...
			sprintf("w l ls %d dt 1 notitle", k));
	end
	k++;
end
gp.export("results/lifetime-x-fits.tex",...
	"cairolatex", "pdf colourtext size 12cm,7cm");
clear gp;

