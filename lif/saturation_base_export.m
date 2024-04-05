pkg load report;

saturation_base;
x = saturation_separate(1);

points = [67 100; 73 101; 78 101; 89 102];

gp = gnuplotter;
gp.load("../gnuplot/style.gp");
gp.load("gnuplot/style-lif.gp");
gp.load("gnuplot/rule-lif.gp");
gp.exec("\n\
	set xrange [50:150] \n\
	set yrange [60:100] reverse \n\
	set ytics 10 \n\
	set xlabel '$\\xpos [\\si\\pixel]$' \n\
	set ylabel '$\\ypos [\\si\\pixel]$' \n\
	set cblabel '$\\lif [\\si\\arbunit]$' offset 2,0 \n\
	#set margins 0, 0, 0, 0 \n\
	#unset tics \n\
	#unset key \n\
	#unset colorbox \n\
	set terminal cairolatex pdf colortext size 12cm,7cm \n\
	set output 'results/saturation-full-example-index.tex' \n\
");
for k = 1:rows(points)
	pos = points(k,[2 1]);
	gp.exec("set arrow from first %d,%d to %d,%d front ls %d",...
		pos + [20, 0], pos, k);
	gp.exec("set label '{[%d,%d]}' left at first %g,%g front tc ls %d",
		pos, pos + [30, 0], k);
end
gp.exec("plot '-' matrix with image");
gp.data(x.img(:,:,24) ./ x.acc);
clear gp;

gp = gnuplotter;
gp.load("../gnuplot/style.gp");
gp.load("../gnuplot/style-cairo.gp");
gp.xlabel('$\\enlaser\\,[\\si{\\micro\\joule}]$');
gp.ylabel('$\\lif\\,[\\si\\arbunit]$');
gp.exec("\n\
	set yrange [0:] \n\
	set xtics 1 \n\
	set ytics 40 \n\
	unset key \n\
");
Escale = 1e6;
for k = 1:length(points)
	EE = cell;
	EE{1} = linspace(min(saturation_separate(1).E), max(x.E));
	EE{2} = linspace(0, max(saturation_separate(2).E));
	gp.clearplot;
	for l = 1:length(saturation_separate)
		s = saturation_separate(l);
		lif = squeeze(s.img(points(k,1), points(k,2), :)) ./ s.acc;
		p = polyfit(s.E, lif, 1);
		gp.plot(s.E * Escale, lif,...
			sprintf("w p lc %d ps 0.2 pt 7", k));
		gp.plot(EE{l} * Escale, polyval(p, EE{l}),...
			sprintf("w l ls %d dt 1", k));
	end
	gp.export(sprintf("results/saturation-full-example-%d.tex", k),...
		"cairolatex", "pdf size 6cm,5cm");
end
