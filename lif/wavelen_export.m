pkg load report;

wavelen_main;

gp = gnuplotter;
gp.load("../gnuplot/style.gp");
gp.load("../gnuplot/style-cairo.gp");
gp.title("bez~prostorového filtru");
gp.xlabel('vlnová délka laseru $\\enlaser\\,[\\si{\\nano\\metre}]$');
gp.ylabel('intenzita $\\lif\\,[\\si\\arbunit]$');
gp.exec("\n\
	set xrange [195.95:196.20] \n\
	set key top right samplen 2 height 1 \n\
");
k = 1;
for x = 1:5
	x = W(k);
	#Em = mean(x.E(:,end));
	gp.plot(x.wl, x.in, sprintf(
		"w l ls %d t '$\\SI{%.1f}{\\micro\\joule}$'", k, x.Em*1e6));
	k++;
end
gp.export("results/excitprof-nofilter.tex", "cairolatex", "size 12cm,8cm");
gp.export("results/excitprof-nofilter-lg.tex", "cairolatex", "size 10cm,8cm");
clear gp k;

gp = gnuplotter;
gp.load("../gnuplot/style.gp");
gp.load("../gnuplot/style-cairo.gp");
gp.title("s~prostorovým filtrem");
gp.xlabel('vlnová délka laseru $\\enlaser\\,[\\si{\\nano\\metre}]$');
gp.ylabel('intenzita $\\lif\\,[\\si\\arbunit]$');
gp.exec("\n\
	set xrange [195.95:196.20] \n\
	set key top right samplen 2 height 1 \n\
");
k = 1;
for x = W(6:10)
	#Em = mean(x.E(:,end));
	gp.plot(x.wl, x.in, sprintf(
		"w l ls %d t '$\\SI{%.2f}{\\micro\\joule}$'", k, x.Em*1e6));
	k++;
end
gp.export("results/excitprof-filter.tex", "cairolatex", "size 12cm,8cm");
gp.export("results/excitprof-filter-lg.tex", "cairolatex", "size 10cm,8cm");
clear gp k;

## Excitation profile fit
gp = gnuplotter();
gp.load("../gnuplot/style.gp");
gp.load("../gnuplot/style-cairo.gp");
gp.xlabel('vlnová délka laseru $\\wavelen\\,[\\si{\\nano\\metre}]$');
gp.ylabel('intenzita LIF $\\lif\\,[\\si\\arbunit]$');
gp.exec("\n\
	set xrange [0.009:0.051] \n\
	set yrange [-0.5:12.5] \n\
	set key top left samplen 2 width 1 \n\
");
xtics = 196.01:0.01:196.05;
gp.exec("set xtics (%s)",...
	sprintf("'\\num{%.2f}' %.2f, ", xtics - [0; 196])(1:end-2));
k = 1;
xx = linspace(196.01, 196.05)';
for x = W(6:10)
	m = 196.01 <= x.wl & x.wl <= 196.05;
	gp.plot(x.wl(m) - 196, x.in(m), sprintf(
		"w p ls %d t '$\\SI{%.2f}{\\micro\\joule}$'", k, x.Em*1e6));
	gp.plot(xx - 196, x.fit.f(xx), sprintf(
		"w l ls %d t ''", k));
	k++;
end
gp.export("results/excitprof-fit.tex", "cairolatex", "pdf size 12cm,8cm");
clear gp k;

D = horzcat(...
	[W.Em]'*1e6,...
	[[W.fit].x0]',...
	[[W.fit].sigma]',...
	[[W.fit].gamma]',...
	[[W.fit].residual]'...
);
f = fopen("results/excitprof-fit.tsv", "w");
fputs(f, "Epulse[uJ]\tpeak[nm]\tsigma[nm]\tgamma[nm]\tresidual\n");
dlmwrite(f, D, "\t");
fclose(f);
