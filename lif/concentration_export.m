pkg load report;
addpath octave;

if (!exist("conc", "var") || !isfield(conc, "n"))
	concentration_main;
end
x = conc;

maxn = quantile(x.n(:), 0.95);
nscale = 10^(-floor(log10(maxn)));

disp("Exporting results/concentration-single.tex...");
gp = gnuplotter;
gp.load("../gnuplot/style.gp");
gp.load("../gnuplot/style-cairo.gp");
gp.load("gnuplot/style-lif.gp");
gp.exec("\n\
	set lmargin at screen 0.12 \n\
	set rmargin at screen 0.88 \n\
	set title 'hustota atomů selenu $\\ndensse\\,[\\si{\\per\\metre\\cubed}]$' \n\
	set yrange [:] reverse \n\
	set xtics 10 \n\
	set ytics 10 \n\
	set xlabel '$\\xpos\\,[\\si\\pixel]$' \n\
	set ylabel '$\\ypos\\,[\\si\\pixel]$' \n\
	unset cblabel \n\
	set terminal cairolatex pdf colortext size 12.5cm,7cm \n\
	set output 'results/concentration-single.tex' \n\
");
gp.exec(...
	'set title "hustota atomů selenu $\\ndensse\\,[10^{%d}\\,\\si{\\per\\metre\\cubed}]$"',...
	-log10(nscale));
gp.exec(sprintf("set cbrange [%g:%g]", 0, maxn * nscale));
x.n(isnan(x.n)) = 0;
gp.plotmatrix(x.xpos, x.ypos, x.n * nscale, "with image");
gp.doplot();
clear gp;
