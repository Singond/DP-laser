pkg load report;
addpath octave;

if (!exist("vertical", "var") || !all(isfield(vertical, {"ins", "n"})))
	concentration_vertical;
end

nscale = 1e-18;

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
	set title '$\\SI{775}{\\sccm}\\,\\ce{Ar} + \\SI{300}{\\sccm}\\,\\ce{H2}$' \n\
	set xrange [-12:12] \n\
	set xtics 5 \n\
	set ytics 5 \n\
	set xlabel 'vodorovná poloha $\\xmm\\,[\\si{\\milli\\metre}]$' \n\
	set ylabel 'výška nad atomizátorem $\\ymm\\,[\\si{\\milli\\metre}]$' \n\
	set terminal cairolatex pdf colortext size 12.5cm,14cm \n\
	set output 'results/concentration-vertical-700+300.tex' \n\
");
gp.exec(...
	'set cblabel "hustota atomů $\\ndensse\\,[10^{%d}\\si{\\per\\metre\\cubed}]$" offset 2,0',...
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

disp("Exporting results/concentration-vertical-compositions.tex...");
gp.exec("\n\
	unset output \n\
	set terminal cairolatex pdf colortext size 12.5cm,11.5cm \n\
	set output 'results/concentration-vertical-compositions.tex' \n\
	set multiplot layout 2,2 margins 0.1, 0.92, 0.12, 0.98 spacing 0.07, 0.12 \n\
	set title offset 0,-0.5 \n\
	set xrange [-11:11] \n\
	set yrange [-1:15.6] \n\
	set cbrange [0:8] \n\
	set xtics 5 \n\
	set ytics 5 \n\
	set cbtics 1 \n\
	unset xlabel \n\
	set ylabel '$\\ymm\\,[\\si{\\milli\\metre}]$' \n\
	unset colorbox \n\
");
k = 1;
for x = vertical(2:4);
	if (mod(k, 2) == 1)
		gp.exec("set ytics out nomirror");
		gp.exec("set ylabel '$\\ymm\\,[\\si{\\milli\\metre}]$'");
	else
		gp.exec("unset ytics");
		gp.exec("unset ylabel");
	end
	if (k == 2)
		gp.exec("set xlabel '$\\xmm\\,[\\si{\\milli\\metre}]$'");
	elseif (k == 3)
		gp.exec("set colorbox user origin graph 1.19, 0 size graph 0.1, 1.0");
		gp.exec(...
			'set cblabel "$\\ndensse\\,[10^{%d}\\si{\\per\\metre\\cubed}]$" offset 8,0',...
			-log10(nscale));
		gp.exec("set cblabel norotate");
	end
	gp.exec(...
		"set title '$\\SI{%d}{\\sccm}\\,\\ce{Ar} + \\SI{%d}{\\sccm}\\,\\ce{H2}$'",...
		x.sccmAr, x.sccmH2);
	gp.plotmatrix(x.xmm, x.ys, x.n * nscale, "with image");
	gp.doplot();
	gp.clearplot();
	k++;
end

disp("Exporting results/concentration-vertical-centre.tex...");
gp = gnuplotter;
gp.load("../gnuplot/style.gp");
gp.load("../gnuplot/style-cairo.gp");
gp.exec(...
	'set ylabel "hustota atomů $\\ndensse\\,[10^{%d}\\si{\\per\\metre\\cubed}]$"',...
	-log10(nscale));
gp.exec("\n\
	set title 'středová oblast' \n\
	set yrange [0:8.5] \n\
	set xlabel 'výška nad atomizátorem $\\ymm\\,[\\si{\\milli\\metre}]$' \n\
	set key top right samplen 1 \n\
");
k = 1;
for x = vertical(1:4);
	gp.plot(x.ys, x.nc * nscale, sprintf(...
		"w p pt 7 ps 0.3 t'\\SI{%d}{\\sccm} \\ce{Ar} + \\SI{%d}{\\sccm} \\ce{H2}'",...
		x.sccmAr, x.sccmH2));
end
gp.export("results/concentration-vertical-centre.tex",...
	"cairolatex", "pdf colourtext size 12cm,8cm");

disp("Exporting results/concentration-vertical-right.tex...");
gp.clearplot;
gp.exec("\n\
	set title 'okrajová oblast' \n\
	set yrange [0:4.5] \n\
	set ytics 1 \n\
");
k = 1;
for x = vertical(1:4);
	gp.plot(x.ys, x.nr * nscale, sprintf(...
		"w p pt 7 ps 0.3 t'\\SI{%d}{\\sccm} \\ce{Ar} + \\SI{%d}{\\sccm} \\ce{H2}'",...
		x.sccmAr, x.sccmH2));
end
gp.export("results/concentration-vertical-right.tex",...
	"cairolatex", "pdf colourtext size 12cm,8cm");
clear gp;
