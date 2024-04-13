pkg load report;
addpath octave;

if (!exist("lifetime", "var"))
	if (isfile("results/lifetime.bin"))
		load results/lifetime.bin
		if (isolderthan("results/lifetime.bin", "lifetime_full.m"))
			warning("loading lifetime data from file older than script");
		end
	else
		lifetime_full;
	end
end

x = lifetime(1);

points = [70 100; 80 100; 80 110; 80 120]';

##
## Fitted parameters
##
disp("Exporting results/lifetime-full-params.tex...");
maxtau = quantile(x.tau(:), 0.95);
gp = gnuplotter;
gp.load("../gnuplot/style.gp");
gp.load("../gnuplot/style-cairo.gp");
gp.load("gnuplot/style-lif.gp");
gp.exec("\n\
	#set style line 3 lt 4 \n\
	#set style line 4 lt 5 \n\
	set lmargin at screen 0.12 \n\
	set rmargin at screen 0.88 \n\
	set title 'doba života $\\lifetime\\,[\\si{\\nano\\second}]$' \n\
	set yrange [:] reverse \n\
	set xtics 10 \n\
	set ytics 10 \n\
	set xlabel '$\\xpos\\,[\\si\\pixel]$' \n\
	set ylabel '$\\ypos\\,[\\si\\pixel]$' \n\
	unset cblabel \n\
	set terminal cairolatex pdf colortext size 12.5cm,7cm \n\
	set output 'results/lifetime-full-params.tex' \n\
");
gp.exec(sprintf("set cbrange [%g:%g]", 0, maxtau));
gp.plotmatrix(x.xpos, x.ypos, x.tau, "with image");
k = 2;
for p = points
	#gp.plot(p(2), p(1), "w p lc 'white'    ps 1.2 pt 4 lw 20 notitle");
	gp.plot(p(2), p(1), sprintf("w p ls %d ps 1.2 pt 4 lw 10 notitle", k));
	k++;
end
gp.doplot();

##
## Fits
##
disp("Exporting results/lifetime-full-fits.tex...");
gp = gnuplotter;
gp.load("../gnuplot/style.gp");
gp.load("../gnuplot/style-cairo.gp");
gp.exec("\n\
	#set style line 3 lt 4 ps 1 \n\
	#set style line 4 lt 5 ps 0.8 \n\
	set terminal cairolatex pdf colortext size 12.5cm,12cm \n\
	set output 'results/lifetime-full-fits.tex' \n\
	set multiplot layout 2,1 margins 0.12, 0.98, 0.10, 0.98 spacing 0.1 \n\
	set xrange [4.5:20.5] \n\
	set yrange [-5:105] \n\
	set ylabel '$\\lif\\,[\\si\\arbunit]$' \n\
	set key top right Left reverse width 1 height 1 samplen 1 \n\
");
p1 = gp.newplot;
k = 2;
for p = points
	xi = interp1(x.xpos, 1:length(x.xpos), p(2), "nearest");
	yi = interp1(x.ypos, 1:length(x.ypos), p(1), "nearest");
	[tmin, tmax] = bounds(x.t);
	tt = linspace(tmin, tmax, 250);
	m = 5 <= x.t & x.t <= 20;
	p1.plot(x.t(m), squeeze(x.in(yi,xi,m)), sprintf(
		"w p ls %d t'$\\lbrack%d,%d\\rbrack\\,\\lifetime=\\SI{%.2f}{\\nano\\second}$'",
		k, p(2), p(1), x.tau(yi, xi)));
	p1.plot(tt, x.fits(yi,xi).fite.f(tt),...
		sprintf("w l ls %d dt 1 notitle", k));
	k++;
end
gp.doplot(p1);
gp.exec("\n\
	set logscale y \n\
	set yrange [5e-3:1.4e2] \n\
	set xlabel '$\\tim\\,[\\si{\\nano\\second}]$' \n\
	unset key \n\
");
gp.doplot(p1);
clear gp;
