pkg load report;
pkg load singon-plasma;
addpath octave;

lifetime_full_load;

x = lifetime(1);
points = [80 100 110];

##
## Fitted parameters
##
disp("Exporting results/lifetime-x-params.tex...");
gp = gnuplotter;
gp.load("../gnuplot/style.gp");
gp.load("../gnuplot/style-cairo.gp");
gp.xlabel('poloha $\\xpos\\,[\\si\\pixel]$');
gp.ylabel('intenzitní parametr $\\lifslope\\,[10^9]$');
gp.exec("\n\
	#set rmargin 8 \n\
	unset key \n\
");
gp.plot(x.xpos, x.taux, "w p ps 0.4 t '$\\lifetime$'");
k = 1;
for xp = points
	gp.exec("set arrow from first %g, graph 0 to first %g, graph 1 ls %d nohead",
		xp, xp, k);
	gp.exec("set label '%d' left at first %g, graph 0.05 tc ls %d rotate by 90 offset -1,0",
		xp, xp, k);
	k++;
end
gp.export("results/lifetime-x-params.tex",...
	"cairolatex", "pdf colourtext size 12cm,8cm");

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
	set xrange [4.5:20.5] \n\
	set yrange [-150:3000] \n\
	@padding \n\
	set key top right samplen 2 \n\
");
k = 1;
for xp = points
	xi = interp1(x.xpos, 1:length(x.xpos), xp, "nearest");
	tmin = 5;
	tmax = 20;
	tt = linspace(8, 15);
	m = tmin <= x.t & x.t <= tmax;
	gp.plot(x.t(m), squeeze(x.inx(1,xi,m)), sprintf(...
		"w p ls %d t'$\\lbrack%d\\rbrack, \\lifetime=\\SI{%.2f}{\\nano\\second}$'",...
		k, xp, x.taux(xi)));
	gp.plot(tt, x.fitsx(xi).fite.f(tt),...
		sprintf("w l ls %d dt 1 notitle", k));
	k++;
end
gp.export("results/lifetime-x-fits.tex",...
	"cairolatex", "pdf colourtext size 12cm,8cm");
clear gp;

##
## Time evolution
##
gp = gnuplotter;
gp.load("../gnuplot/style.gp");
gp.load("../gnuplot/style-cairo.gp");
gp.load("../gnuplot/style-splot.gp");
gp.exec("\n\
	set style fill transparent solid 0.3 \n\
	set tmargin at screen 0.82 \n\
	set bmargin at screen 0.25 \n\
	set lmargin at screen 0.24 \n\
	set rmargin at screen 0.85 \n\
	set yrange noextend \n\
	set ytics 20 \n\
	set ztics 400 \n\
	set xyplane at 0 \n\
	set autoscale noextend \n\
	#set view 60, 360-37.5 \n\
	unset key \n\
	set offsets graph 0.04, graph 0.04, graph 0.04, graph 0.04 \n\
	set terminal cairolatex pdf size 12.5cm,10cm \n\
	set output 'results/lifetime-x-time.tex' \n\
");
gp.exec('set xlabel "čas $\\tim\\,[\\si{\\nano\\second}]$" offset -1,-0.5 rotate parallel');
gp.exec('set ylabel "poloha $\\xpos\\,[\\si\\pixel]$" offset -1,0 rotate parallel');
gp.exec('set zlabel "intenzita LIF $\\lif\\,[\\si\\arbunit]$" offset -1,0');
gp.exec("splot '-' with zerrorfill ls 1, '-' with lines ls 1");
sz = size(x.xpos');
for k = 1:numel(x.t)
	D = [x.t(k)(ones(sz)) x.xpos' x.inx(:,:,k)' zeros(sz) x.inx(:,:,k)'];
	gp.data(D, "\n\n");
end
gp.exec("e");
for k = 1:numel(x.t)
	D = [x.t(k)(ones(sz)) x.xpos' x.inx(:,:,k)'];
	gp.data(D, "\n\n");
end
gp.exec("e");
clear gp;
