pkg load report;

if (!exist("R", "var") || !exist("Rt", "var"))
	rayleigh;
end

gp = gnuplotter;
gp.load("../style.gp");
gp.load("../style-cairo.gp");
gp.load("gnuplot/style-lif.gp");
gp.load("gnuplot/rule-lif.gp");
gp.exec("\n\
	set size ratio -1 \n\
	set yrange [:] reverse \n\
	set xlabel '$\\xpos\\,[\\si\\pixel]$' \n\
	set ylabel '$\\ypos\\,[\\si\\pixel]$' \n\
	unset margins \n\
	unset key \n\
	unset colorbox \n\
	set terminal cairolatex pdf colortext size 12cm,8cm \n\
	set output 'results/rayleigh-example.tex' \n\
	plot '-' matrix with image \n\
");
gp.data(R(1).inm);
clear gp;

gp = gnuplotter;
gp.load("../style.gp");
gp.load("../style-cairo.gp");
gp.exec("\n\
	set key top left width 1 height 1 \n\
	set autoscale noextend \n\
	set offsets graph 0.04, graph 0.04, graph 0.04, graph 0.04 \n\
");
for r = R
	gp.plot(r.ypos, r.iny, sprintf(...
		'w l t "$\\\\SI{%.2f}{\\\\micro\\\\joule}$"', r.Em*1e6));
end
gp.xlabel('svislá poloha $\\ypos\\,[\\si\\pixel]$');
gp.ylabel('intenzita LIF $\\lif\\,[\\si\\arbunit]$');
gp.export("results/rayleigh-profile.tex", "cairolatex", "pdf size 12cm,8cm");
clear gp;

gp = gnuplotter;
gp.load("../style.gp");
gp.load("../style-cairo.gp");
gp.load("../gnuplot/style-splot.gp");
gp.exec("\n\
	set style fill transparent solid 0.3 \n\
	set yrange [0:] reverse \n\
	set ztics 400 \n\
	set xyplane at 0 \n\
	set autoscale noextend \n\
	#set view 60, 360-37.5 \n\
	unset key \n\
	set offsets graph 0.04, graph 0.04, graph 0.04, graph 0.04 \n\
	set terminal cairolatex pdf size 14cm,12cm \n\
	set output 'results/rayleigh-time.tex' \n\
");
gp.exec('set xlabel "čas $\\tim\\,[\\si\\second]$" offset -1,0');
gp.exec('set ylabel "poloha $\\ypos\\,[\\si\\pixel]$" offset 1,-1');
gp.exec('set zlabel "intenzita LIF $\\lif\\,[\\si\\arbunit]$" offset -1,0');
gp.exec("splot '-' with zerrorfill ls 1, '-' with lines ls 1");
sz = size(Rt.ypos);
for k = 1:rows(Rt.t')
	D = [Rt.t(k)(ones(sz)) Rt.ypos Rt.iny(:,k) zeros(sz) Rt.iny(:,k)];
	gp.data(D, "\n\n");
end
gp.exec("e");
for k = 1:rows(Rt.t')
	D = [Rt.t(k)(ones(sz)) Rt.ypos Rt.iny(:,k)];
	gp.data(D, "\n\n");
end
gp.exec("e");
clear gp;
