pkg load report;

wavelen_main;

gp = gnuplotter;
gp.load("../gnuplot/style.gp");
gp.load("../gnuplot/style-cairo.gp");
gp.xlabel('$\\tim\\,[\\si{\\second}]$');
gp.ylabel('$\\enlaser\\,[\\si{\\micro\\joule}]$');
gp.exec("\n\
	set tmargin at screen 0.95 \n\
	set rmargin at screen 0.95 \n\
	set xrange [0:400] \n\
	set yrange [4:14] \n\
	set xtics 100 offset 0,0.3 \n\
	set xlabel offset 0,0.8 \n\
	unset key \n\
");
edata = W(1).pwrdata{1};
gp.plot(edata(:,1), edata(:,2)*1e6, "w l ls 1");
gp.export("results/example-pwrdata-small.tex",
	"cairolatex", "pdf size 5.4cm,4cm");

Em = mean(edata(:,2));
Estd = std(edata(:,2));
printf("mean pulse energy:      %f uJ\n", Em * 1e6);
printf("pulse energy st. dev:   %f uJ (%f %%)\n",...
	Estd * 1e6, 100 * Estd / Em);

