pkg load report;
addpath octave;

if (!exist("saturation", "var") || !isfield(saturation, "lifx"))
	saturation_x;
end
if (!exist("saturationt", "var"))
	saturation_overall;
end

x = saturation(3);

points = [80 100 110];
Escale = 1e6;
ascale = 1e-9;
bscale = 1e-6;

disp("Exporting results/saturation-x-params.tex...");
gp = gnuplotter;
gp.load("../gnuplot/style.gp");
gp.load("../gnuplot/style-cairo.gp");
gp.xlabel('poloha $\\xpos\\,[\\si\\pixel]$');
gp.ylabel('intenzitní parametr $\\lifslope\\,[10^9]$');
gp.exec("\n\
	set rmargin 8 \n\
	set ytics in nomirror \n\
	set y2tics in nomirror \n\
	set y2label 'saturační parametr $\\lifsat\\,[\\si{\\per\\micro\\joule}]$' \n\
	set key top left Left reverse samplen 2 width 1 \n\
");
gp.plot(x.xpos, x.fitex.a * ascale, "w p ps 0.4 t '$\\lifslopex$'");
gp.plot(x.xpos, x.fitex.b * bscale, "w p ps 0.5 axes x1y2 t '$\\lifsatx$'");
bt = saturationt.fite.b * bscale;
gp.plot(sprintf("%g", bt),...
	"w l axes x1y2 ls 2 dt '_' notitle");
gp.exec(horzcat("set label '$\\lifsatt = \\SI{%.3f}{\\per\\micro\\joule}$' ",...
	"tc ls 2 at graph 0.21, second %g center offset 0,0.6"),...
	bt, bt);
k = 1;
for xp = points
	gp.exec("set arrow from first %g, graph 0 to first %g, graph 1 ls %d nohead",
		xp, xp, k++);
end
gp.export("results/saturation-x-params.tex",...
	"cairolatex", "pdf colourtext size 12cm,8cm");

disp("Exporting results/saturation-x-fits.tex...");
gp = gnuplotter;
gp.load("../gnuplot/style.gp");
gp.load("../gnuplot/style-cairo.gp");
gp.xlabel('energie pulzu $\\enlaser\\,[\\si{\\micro\\joule}]$');
gp.ylabel('intenzita fluorescence $\\lif\\,[\\si\\arbunit]$');
gp.exec("\n\
	set xrange noextend \n\
	set yrange noextend \n\
	@padding \n\
	set key top left Left reverse samplen 2 \n\
");
k = 1;
for xp = points
	xi = interp1(x.xpos, 1:length(x.xpos), xp, "nearest");
	[Lmin, Lmax] = bounds(x.L);
	LL = linspace(Lmin, Lmax);
	gp.plot(x.L * Escale, squeeze(x.lifx(1,xi,:)), sprintf(...
		"w p ls %d t'$\\lbrack%d\\rbrack, \\lifsat=\\SI{%.2f}{\\lifsatunit}$'",...
		k, xp, x.fitex.b(xi) * bscale));
	gp.plot(LL * Escale, x.fitex.f(1, xi, LL),...
		sprintf("w l ls %d dt 1 notitle", k));
	k++;
end
gp.export("results/saturation-x-fits.tex",...
	"cairolatex", "pdf colourtext size 12cm,8cm");
clear gp;
