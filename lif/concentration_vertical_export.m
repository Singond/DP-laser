pkg load report;
addpath octave;

if (!exist("vertical", "var") || !isfield(vertical, "ins"))
	concentration_vertical;
end
x = vertical(2);

nscale = 1e-15;

disp("Exporting results/concentration-vertical-700+300.tex...");
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
	set xlabel 'vodorovná poloha $\\xpos\\,[\\si{\\milli\\metre}]$' \n\
	set ylabel 'výška nad atomizátorem $\\ypos\\,[\\si{\\milli\\metre}]$' \n\
	set terminal cairolatex pdf colortext size 12.5cm,14cm \n\
	set output 'results/concentration-vertical-700+300.tex' \n\
");
gp.exec(...
	'set cblabel "hustota atomů $\\ndensse\\,[10^{%d}\\si{\\per\\metre\\cubed}]$" offset 1,0',...
	-log10(nscale));
gp.plotmatrix(x.xmm, x.ys, x.n * nscale, "with image");
gp.doplot();
gp.clearplot();

clear gp;
