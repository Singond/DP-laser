pkg load report;
addpath octave;

if (!exist("vertical", "var") || !isfield(vertical, "ins"))
	concentration_vertical;
end

nscale = 1e-15;

disp("Exporting results/concentration-vertical-700+300.tex...");
x = vertical(2);
gp = gnuplotter;
gp.load("../gnuplot/style.gp");
gp.load("../gnuplot/style-cairo.gp");
gp.load("gnuplot/style-lif.gp");
gp.exec("\n\
	set palette viridis \n\
	set lmargin at screen 0.12 \n\
	set rmargin at screen 0.83 \n\
	set title '$\\SI{700}{\\sccm}\\,\\ce{Ar} + \\SI{300}{\\sccm}\\,\\ce{H2}$' \n\
	set xrange [-12:12] \n\
	set xtics 5 \n\
	set ytics 5 \n\
	set xlabel 'vodorovná poloha $\\xmm\\,[\\si{\\milli\\metre}]$' \n\
	set ylabel 'výška nad atomizátorem $\\ymm\\,[\\si{\\milli\\metre}]$' \n\
	set terminal cairolatex pdf colortext size 12.5cm,14cm \n\
	set output 'results/concentration-vertical-700+300.tex' \n\
");
gp.exec(...
	'set cblabel "hustota atomů $\\ndensse\\,[10^{%d}\\si{\\per\\metre\\cubed}]$" offset 1,0',...
	-log10(nscale));
gp.plotmatrix(x.xmm, x.ys, x.n * nscale, "with image");
gp.doplot();
gp.clearplot();

gp.exec("\n\
	set xrange [-11:11] \n\
	set yrange [-1:16] \n\
	set xtics 5 \n\
	set ytics 5 \n\
	set terminal cairolatex pdf colortext size 6cm,6cm \n\
");
for x = vertical(2:4)
	name = sprintf("results/concentration-vertical-%d+%d-s.tex",...
		x.sccmAr, x.sccmH2);
	printf("Exporting %s...\n", name);
	gp.exec("set output '%s'", name);
	gp.exec(...
		"set title '$\\SI{%d}{\\sccm}\\,\\ce{Ar} + \\SI{%d}{\\sccm}\\,\\ce{H2}$'",...
		x.sccmAr, x.sccmH2);
	gp.plotmatrix(x.xmm, x.ys, x.n * nscale, "with image");
	gp.doplot();
	gp.clearplot();
end

clear gp;
