pkg load report;
addpath octave;

concentration_load;
x = conc;

nscale = 1e-18;

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
[~, imax] = max(conc.E);
n = x.nf(:,:,imax);
gp.plotmatrix(x.xpos, x.ypos, n * nscale, "with image");
gp.doplot();
gp.clearplot();

disp("Exporting results/concentration-mean.tex...");
gp.exec("\n\
	set output 'results/concentration-mean.tex' \n\
");
gp.plotmatrix(x.xpos, x.ypos, x.nm * nscale, "with image");
gp.doplot();
gp.clearplot();

disp("Exporting results/concentration-std.tex...");
gp.exec("\n\
	unset cbrange \n\
	set output 'results/concentration-std.tex' \n\
");
gp.exec(...
	'set title "nejistota $\\ndensseunc\\,[10^{%d}\\,\\si{\\per\\metre\\cubed}]$"',...
	-log10(nscale));
gp.plotmatrix(x.xpos, x.ypos, x.n_std * nscale, "with image");
gp.doplot();
clear gp;
